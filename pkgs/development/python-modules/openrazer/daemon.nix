{
  lib,
  callPackage,
  buildPythonPackage,
  daemonize,
  dbus-python,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  pygobject3,
  pyudev,
  setproctitle,
  setuptools,
  wrapGAppsNoGuiHook,
  notify2,
  glib,
}:

buildPythonPackage rec {
  pname = "openrazer-daemon";
  version = src.version;

  src = (callPackage ./common.nix { }).src;

  outputs = [
    "out"
    "man"
  ];

  sourceRoot = "${src.name}/daemon";

  postPatch = ''
    substituteInPlace openrazer_daemon/daemon.py \
      --replace-fail "plugdev" "openrazer"
  '';

  nativeBuildInputs = [
    setuptools
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
  ];

  propagatedBuildInputs = [
    daemonize
    dbus-python
    pygobject3
    pyudev
    setproctitle
    notify2
  ];

  postInstall = ''
    DESTDIR="$out" PREFIX="" make manpages install-resources install-systemd
  '';

  pyproject = true;

  # no tests run
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Entirely open source user-space daemon that allows you to manage your Razer peripherals on GNU/Linux";
    mainProgram = "openrazer-daemon";
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ] ++ lib.teams.lumiguide.members;
    platforms = with lib.platforms; linux;
  };
}
