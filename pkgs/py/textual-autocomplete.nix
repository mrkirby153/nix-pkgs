{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "textual-autocomplete";
  version = "3.0.0a9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "textual-autocomplete";
    rev = "bbacfa91bfd9ff006dab8930a8a3fe4ba46853ab";
    hash = "sha256-m2ATH2BNoVCoEzKb5xxe4KPvUlfrwfE+widRIdApkL8=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = [
    python3.pkgs.textual
    python3.pkgs.typing-extensions
  ];

  pythonImportsCheck = ["textual_autocomplete"];

  meta = {
    description = "Easily add autocomplete dropdowns to your Textual apps";
    homepage = "https://github.com/darrenburns/textual-autocomplete";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [taha-yassine];
  };
}
