{ lib, python3, fetchFromGitHub, callPackage }:
let
  textual-autocomplete = callPackage ./textual-autocomplete.nix {};
in
python3.pkgs.buildPythonApplication rec {
  pname = "posting";
  version = "1.8.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    rev = version;
    hash = "sha256-pLL6jBdgdrlltM0qqqCZy/bDJ0uAx9NoU0K05zUs1vM=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    click-default-group
    httpx
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    pyyaml
    textual
    textual-autocomplete
    xdg-base-dirs
  ] ++ httpx.optional-dependencies.brotli ++ textual.optional-dependencies.syntax;

  pythonRelaxDeps = true;

  pythonImportsCheck = ["posting"];
}