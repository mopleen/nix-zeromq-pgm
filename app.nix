{ }:
let
  src = import nix/sources.nix;
  pkgs = import src.nixpkgs { };
  zeromq = pkgs.callPackage ./default.nix { inherit pkgs; };
in pkgs.callPackage ./app { inherit zeromq; }
