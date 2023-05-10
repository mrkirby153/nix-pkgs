{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "dwmblocks";
  src = pkgs.fetchFromGitHub {
    repo = "dwmblocks";
    owner = "mrkirby153";
    rev = "cab6979eae0d5761b316baa2ee464b87f86fced8";
    sha256 = "sha256-FnxQ5bfIs3qg9ZMhQSuGd9TJsEeAhJqmQ8XReFlPqG0=";
  };
  buildInputs = with pkgs; [
    xorg.libX11
    pkg-config
  ];
  makeFlags = ["PREFIX=$(out)"];
}
