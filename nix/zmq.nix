{ lib, stdenv, fetchFromGitHub, cmake, asciidoc, pkg-config, libsodium
, enableDrafts ? false, pgm }:

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "sha256-epOEyHOswUGVwzz0FLxhow/zISmZHxsIgmpOV8C8bQM=";
  };

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = [ libsodium ];
  propagatedBuildInputs = [ pgm ];

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = [
    "-DOPENPGM_PKGCONFIG_NAME=openpgm-5.3"
    "-DWITH_OPENPGM=ON"
    "-DBUILD_TESTS=OFF"
    "-DWITH_DOCS=OFF"
    "-DWITH_PERF_TOOL=OFF"
  ] ++ lib.optional enableDrafts "-DENABLE_DRAFTS=ON";

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
