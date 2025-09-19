{
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
}: let
  extra_dependencies = with python3.pkgs; {
    arrapi = {
      version = "1.4.13";
      hash = "sha256-0V2lci1nRkkGfpWXMY7pHl1TYwOdrU5Jl4XAvm/UInE=";
      deps = [
        requests
      ];
    };
    tmdbapis = {
      version = "1.2.28";
      hash = "sha256-mSK9c1PDBjR/j+ROHBMe0sYo4TD8cm8bqnhKPbNcRtw=";
      deps = [
        requests
      ];
    };
  };

  asPackages = builtins.mapAttrs (name: value:
    python3.pkgs.buildPythonPackage rec {
      pname = name;
      version = value.version;
      src = python3.pkgs.fetchPypi {
        inherit pname;
        version = value.version;
        hash = value.hash;
      };
      propagatedBuildInputs = value.deps;
      build-system = [python3.pkgs.setuptools];
      pyproject = true;
    })
  extra_dependencies;

  pythonEnvironment = python3.withPackages (ps:
    with ps;
      [
        gitpython
        lxml
        num2words
        pathvalidate
        pillow
        plexapi
        psutil
        python-dotenv
        python-dateutil
        requests
        retrying
        ruamel-yaml
        schedule
        setuptools
      ]
      ++ (builtins.attrValues asPackages));
in
  stdenv.mkDerivation rec {
    pname = "kometa";
    version = "2.2.1";

    src = fetchFromGitHub {
      owner = "Kometa-Team";
      repo = "Kometa";
      rev = "v${version}";
      hash = "sha256-2RmnnKQRVL1/WYD2tL9GBVF8n1n6EGp835l+Z+Bn7Hk=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out $out/bin
      cp -r $src $out/lib
      echo "#!${pythonEnvironment}/bin/python3" > $out/bin/kometa
      cat $src/kometa.py >> $out/bin/kometa
      cp $src/VERSION $out/bin/VERSION
      chmod +x $out/bin/kometa
      wrapProgram $out/bin/kometa --prefix PYTHONPATH : $out/lib
    '';
  }
