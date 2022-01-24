{ pkgs }:
let
  pgm = pkgs.callPackage nix/pgm.nix { };
  zeromq = pkgs.callPackage nix/zmq.nix { inherit pgm; };
in zeromq
