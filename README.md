# nix-zeromq-pgm
ZeroMQ with PGM

## Example usage
```
{ }:
let
  src = import nix/sources.nix;
  pkgs = import src.nixpkgs { };
  zeromq_pgm_src = pkgs.fetchFromGitHub {
    owner = "mopleen";
    repo = "nix-zeromq-pgm";
    rev = "11719dc6d7034b0c26f1af39827b0e96551ba930";
    sha256 = "sha256-Y2giVrY9INjPiJH1hpFQ4cI3a+cUykczNOZp2D+dKMs=";
  };
  zeromq = import zeromq_pgm_src { inherit pkgs; };
in zeromq
```
