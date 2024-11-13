{
  lib,
  callPackage,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  numpy,
  openrazer-daemon,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openrazer";
  version = src.version;

  src = (callPackage ./common.nix { }).src;

  sourceRoot = "${src.name}/pylib";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dbus-python
    numpy
    openrazer-daemon
  ];

  pyproject = true;

  # no tests run
  doCheck = false;

  meta = {
    description = "Entirely open source Python library that allows you to manage your Razer peripherals on GNU/Linux";
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ] ++ lib.teams.lumiguide.members;
    platforms = with lib.platforms; linux;
  };
}
