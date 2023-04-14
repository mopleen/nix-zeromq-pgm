{
  description = "nix-zeromq-pgm";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = rec {
        pgm = pkgs.callPackage nix/pgm.nix {};
        zeromq = pkgs.callPackage nix/zmq.nix {inherit pgm;};

        mold = pkgs.callPackage nix/mold.nix {stdenv = pkgs.llvmPackages_latest.stdenv;};
        mold_env = pkgs.callPackage nix/mold_env.nix {inherit mold;};

        # boost182 = let
        #   version = "1.82.0";
        #   cp = nixFile: args:
        #     pkgs.callPackage nixFile (args
        #       // {
        #         inherit version;
        #         src = boostSrc;
        #       });
        #   boostSrc = pkgs.fetchurl {
        #     urls = [
        #       "https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.bz2"
        #     ];
        #     # SHA256 from http://www.boost.org/users/history/version_1_82_0.html
        #     sha256 = "a6e1ab9b0860e6a2881dd7b21fe9f737a095e5f33a3a874afc6a345228597ee6";
        #   };
        # in
        #   pkgs.boost.override {callPackage = cp;};

        app = pkgs.callPackage ./app {
          inherit zeromq;
          stdenv = mold_env;
          boost = pkgs.boost181;
        };

        default = app;
      };
    });
}
