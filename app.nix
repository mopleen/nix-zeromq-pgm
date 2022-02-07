{ }:
let
  src = import nix/sources.nix;
  pkgs = import src.nixpkgs { };

  customStdenv = pkgs.stdenv;

  moldStdenv = pkgs.callPackage nix/mold_env.nix { stdenv = customStdenv; };

  zeromq = pkgs.callPackage ./default.nix { inherit pkgs; };
in pkgs.callPackage ./app {
  inherit zeromq;
  stdenv = moldStdenv;
}
