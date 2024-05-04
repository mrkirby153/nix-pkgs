{ lib
, buildGoModule
, rustPlatform
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, CoreFoundation
, AppKit
, libfido2
, nodejs
, openssl
, pkg-config
, Security
, stdenv
, xdg-utils
, wasm-pack
, yarn
, prefetch-yarn-deps
, nixosTests
, rust-bin
, wasm-bindgen-cli
, fixup-yarn-lock

, withRdpClient ? true

, version
, hash
, vendorHash
, extPatches ? null
, cargoHash ? null
, cargoLock ? null
, yarnHash
}:
let
  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    inherit hash;
  };
  inherit version;

  rdpClient = rustPlatform.buildRustPackage rec {
    pname = "teleport-rdpclient";
    inherit cargoHash cargoLock;
    inherit version src;

    buildAndTestSubdir = "lib/srv/desktop/rdp/rdpclient";

    buildInputs = [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];
    nativeBuildInputs = [ pkg-config ];

    # https://github.com/NixOS/nixpkgs/issues/161570 ,
    # buildRustPackage sets strictDeps = true;
    nativeCheckInputs = buildInputs;

    OPENSSL_NO_VENDOR = "1";

    postInstall = ''
      mkdir -p $out/include
      cp ${buildAndTestSubdir}/librdprs.h $out/include/
    '';
  };

  wasm = rustPlatform.buildRustPackage {
    name = "teleport-wasm";
    inherit version src cargoLock;

    nativeBuildInputs = [ wasm-pack (rust-bin.stable.latest.default.override {
      targets = ["wasm32-unknown-unknown"];
    }) (wasm-bindgen-cli.override {
      version = "0.2.91";
      hash = "sha256-f/RK6s12ItqKJWJlA2WtOXtwX4Y0qa8bq/JHlLTAS3c=";
      cargoHash = "sha256-3vxVI0BhNz/9m59b+P2YEIrwGwlp7K3pyPKt4VqQuHE=";
    })  ];

    doCheck = false;
    buildPhase = ''
      export HOME=$(mktemp -d)
      cd web/packages/teleport
      wasm-pack build ./src/ironrdp --target web --mode no-install -- --offline
    '';
    installPhase = ''
      mkdir -p $out
      cp -R ./src/ironrdp/pkg/* $out
    '';
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = yarnHash;
  };

  webassets = stdenv.mkDerivation {
    pname = "teleport-webassets";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      yarn
      prefetch-yarn-deps
      fixup-yarn-lock
    ];
    buildInputs = [
      wasm-pack
    ];

    configurePhase = ''
      export HOME=$(mktemp -d)
    '';

    buildPhase = ''
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup-yarn-lock yarn.lock

      yarn install --offline \
        --frozen-lockfile \
        --ignore-engines --ignore-scripts

      mkdir -p web/packages/teleport/src/ironrdp/pkg
      cp -Rv ${wasm}/* web/packages/teleport/src/ironrdp/pkg
      patchShebangs .

      yarn workspace @gravitational/teleport vite build
    '';

    installPhase = ''
      mkdir -p $out
      cp -R webassets/. $out
    '';
  };
in
buildGoModule rec {
  pname = "teleport";

  inherit src version;
  inherit vendorHash;
  proxyVendor = true;

  subPackages = [ "tool/tbot" "tool/tctl" "tool/teleport" "tool/tsh" ];
  tags = [ "libfido2" "webassets_embed" ]
    ++ lib.optional withRdpClient "desktop_access_rdp";

  buildInputs = [ openssl libfido2 ]
    ++ lib.optionals (stdenv.isDarwin && withRdpClient) [ CoreFoundation Security AppKit ];
  nativeBuildInputs = [ makeWrapper pkg-config ];

  patches = extPatches ++ [
    ./0001-fix-add-nix-path-to-exec-env.patch
    ./rdpclient.patch
  ];

  # Reduce closure size for client machines
  outputs = [ "out" "client" ];

  preBuild = ''
    cp -r ${webassets} webassets
  '' + lib.optionalString withRdpClient ''
    ln -s ${rdpClient}/lib/* lib/
    ln -s ${rdpClient}/include/* lib/srv/desktop/rdp/rdpclient/
  '';

  # Multiple tests fail in the build sandbox
  # due to trying to spawn nixbld's shell (/noshell), etc.
  doCheck = false;

  postInstall = ''
    mkdir -p $client/bin
    mv {$out,$client}/bin/tsh
    # make xdg-open overrideable at runtime
    wrapProgram $client/bin/tsh --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    ln -s {$client,$out}/bin/tsh
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/tsh version | grep ${version} > /dev/null
    $client/bin/tsh version | grep ${version} > /dev/null
    $out/bin/tbot version | grep ${version} > /dev/null
    $out/bin/tctl version | grep ${version} > /dev/null
    $out/bin/teleport version | grep ${version} > /dev/null
  '';

  passthru.tests = nixosTests.teleport;

  meta = with lib; {
    description = "Certificate authority and access plane for SSH, Kubernetes, web applications, and databases";
    homepage = "https://goteleport.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ arianvp justinas sigma tomberek freezeboy techknowlogick ];
    platforms = platforms.unix;
    # go-libfido2 is broken on platforms with less than 64-bit because it defines an array
    # which occupies more than 31 bits of address space.
    broken = stdenv.hostPlatform.parsed.cpu.bits < 64;
  };
}