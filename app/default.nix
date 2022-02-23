{ stdenv, cmake, cppzmq, zeromq, boost, gcc-unwrapped }:
stdenv.mkDerivation {
  pname = "app";
  version = "0.0";
  src = ./.;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ cppzmq zeromq boost ];
  NIX_CFLAGS_COMPILE = [ "-flto -fno-fat-lto-objects" ];
  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar" "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];
}

