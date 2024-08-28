{
  lib,
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
  nix-update-script,
  wrapGAppsNoGuiHook,
  notify2,
  glib,
}:

buildPythonPackage rec {
  pname = "openrazer-daemon";
  version = "3.8.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-eV5xDFRQi0m95pL6e2phvblUbh5GEJ1ru1a62TnbGNk=";
  };

  outputs = [
    "out"
    "man"
  ];

  sourceRoot = "source/daemon";

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

  # no tests run
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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
