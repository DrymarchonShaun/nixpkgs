{
  lib,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,
  setuptools,
  unrar,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-unrar";
  version = "0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "unrar";
    inherit (finalAttrs) version;
    hash = "sha256-skRHpbkwJL5gDvglVmi6I6MPRRF2V3tpFVnqE1n30WQ=";
  };

  postPatch = ''
    substituteInPlace unrar/unrarlib.py \
      --replace-fail "os.environ.get('UNRAR_LIB_PATH', None)" "${unrar}/lib/libunrar.so"
  '';

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "unrar"
  ];

  dontCheckPythonMetadata = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrapper for UnRAR library, ctypes-based";
    homepage = "https://pypi.org/project/unrar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
  };
})
