{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm

, pytest
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x/W+9/R3I8U0ION3vGTSVThDvui8rF8K0HarFSR4ABg=";
  };


  build-system = [
    setuptools
    setuptools-scm
  ];


  pythonImportsCheck = [ "bcj" "lzma" ];

  meta = with lib; {
    homepage = "https://codeberg.org/miurahr/pybcj";
    description = "BCJ(Branch-Call-Jump) filter for python";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ByteSudoer ];
  };
}
