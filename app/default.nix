{ stdenv, cmake, cppzmq, zeromq }:
stdenv.mkDerivation {
  pname = "app";
  version = "0.0";
  src = ./.;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ cppzmq zeromq ];
}
