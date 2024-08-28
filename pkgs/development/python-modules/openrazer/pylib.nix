{
  lib,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  numpy,
  openrazer-daemon,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "openrazer";
  version = "3.8.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-eV5xDFRQi0m95pL6e2phvblUbh5GEJ1ru1a62TnbGNk=";
  };

  sourceRoot = "source/pylib";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dbus-python
    numpy
    openrazer-daemon
  ];

  # no tests run
  doCheck = false;

  passthru.updateScript = nix-update-script { };
  meta = {
    homepage = "https://openrazer.github.io/";
    description = "Entirely open source Python library that allows you to manage your Razer peripherals on GNU/Linux";
    license = with lib.licenses; gpl2Only;
    maintainers =
      with lib.maintainers;
      [
        evanjs
        DrymarchonShaun
      ]
      ++ lib.teams.lumiguide.members;
    mainProgram = "openrazer-daemon";
    platforms = with lib.platforms; linux;
  };
}
