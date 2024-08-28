{
  coreutils,
  fetchFromGitHub,
  kernel,
  stdenv,
  lib,
  util-linux,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "3.8.0";
  pname = "openrazer-${finalAttrs.version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eV5xDFRQi0m95pL6e2phvblUbh5GEJ1ru1a62TnbGNk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall

    binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
    mkdir -p "$binDir"
    cp -v driver/*.ko "$binDir"
    RAZER_MOUNT_OUT="$out/bin/razer_mount"
    RAZER_RULES_OUT="$out/etc/udev/rules.d/99-razer.rules"
    install -m 644 -v -D install_files/udev/99-razer.rules $RAZER_RULES_OUT
    install -m 755 -v -D install_files/udev/razer_mount $RAZER_MOUNT_OUT
    substituteInPlace $RAZER_RULES_OUT \
      --replace razer_mount $RAZER_MOUNT_OUT \
      --replace plugdev openrazer
    substituteInPlace $RAZER_MOUNT_OUT \
      --replace /usr/bin/logger ${util-linux}/bin/logger \
      --replace chgrp ${coreutils}/bin/chgrp \
      --replace "PATH='/sbin:/bin:/usr/sbin:/usr/bin'" "" \
      --replace plugdev openrazer

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://openrazer.github.io/";
    description = "Entirely open source Linux driver that allows you to manage your Razer peripherals on GNU/Linux";
    license = with lib.licenses; gpl2Only;
    maintainers =
      with lib.maintainers;
      [
        evanjs
        DrymarchonShaun
      ]
      ++ lib.teams.lumiguide.members;
    mainProgram = "razer_mount";
    platforms = with lib.platforms; linux;
    broken = kernel.kernelOlder "4.19";
  };
})
