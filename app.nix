{ }:
let
  src = import nix/sources.nix;

  big_overlay = import "${src.nur-packages}/overlay.nix";
  oneapi_overlay = import "${src.nur-packages}/overlays/intel-oneapi";

  pkgs = import src.nixpkgs { overlays = [big_overlay oneapi_overlay]; };

  customStdenv = pkgs.oneapiPackages_2021_3_1.stdenv;

  moldStdenv = pkgs.callPackage nix/mold_env.nix { stdenv = customStdenv; };

  zeromq = pkgs.zeromq; # pkgs.callPackage ./default.nix { inherit pkgs; };

  boost178 = let
    cp = nixFile: args:
      pkgs.callPackage nixFile (args // {
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
  stdenv = customStdenv;
  # stdenv = moldStdenv;
  # boost = boost178;
}

