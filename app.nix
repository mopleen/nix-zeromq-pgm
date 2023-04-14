{ }:
let
  src = import nix/sources.nix;
  pkgs = import src.nixpkgs { };

  customStdenv = pkgs.stdenv;

  moldStdenv = pkgs.callPackage nix/mold_env.nix { stdenv = customStdenv; };

  zeromq = pkgs.callPackage ./default.nix { inherit pkgs; };

  boost178 = let
    injectFlags = stdenv:
      stdenv // {
        mkDerivation = args:
          stdenv.mkDerivation (args // {
            NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "")
              + " -fno-gnu-unique -fwtfalexsuper";
          });
      };

    cp = nixFile: args:
      pkgs.callPackage nixFile (args // {
        stdenv = injectFlags pkgs.stdenv;
        version = "1.78.0";
        src = boostSrc;
      });
    boostSrc = pkgs.fetchurl {
      urls = [
        "mirror://sourceforge/boost/boost_1_78_0.tar.bz2"
        "https://dl.bintray.com/boostorg/release/1.78.0/source/boost_1_78_0.tar.bz2"
      ];
      # SHA256 from http://www.boost.org/users/history/version_1_78_0.html
      sha256 =
        "8681f175d4bdb26c52222665793eef08490d7758529330f98d3b29dd0735bccc";
    };
  in pkgs.boost.override { callPackage = cp; };

in pkgs.callPackage ./app {
  inherit zeromq;
  # stdenv = moldStdenv;
  boost = boost178;
}

