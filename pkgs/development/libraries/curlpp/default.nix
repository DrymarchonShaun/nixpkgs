{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
}:

stdenv.mkDerivation {
  pname = "curlpp";
  version = "0.8.1-unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "jpbarrette";
    repo = "curlpp";
    rev = "8840ec806a75a6def9ed07845a620f6d170e5821";
    hash = "sha256-WkYCb+830RgMrM6wRFunPxcvcziNa7qCjUqqlwlJHAk=";
  };

  patches = [
    # https://github.com/jpbarrette/curlpp/pull/171
    ./curl_8_10_build_failure.patch
  ];

  buildInputs = [ curl ];
  nativeBuildInputs = [ cmake ];

  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/*.pc \
      --replace-fail '=''${exec_prefix}//' '=/' \
      --replace-fail '=''${prefix}//' '=/'
  '';

  meta = with lib; {
    homepage = "https://www.curlpp.org/";
    description = "C++ wrapper around libcURL";
    mainProgram = "curlpp-config";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
