{ callPackage, llvmPackages_latest, stdenv, runCommand, symlinkJoin, overrideCC
, bintools }:
let
  mold = callPackage ./mold.nix { stdenv = llvmPackages_latest.stdenv; };

  overrideBintoolsUnwrapped = bintools: bintools-unwrapped:
    bintools.override ({
      bintools = symlinkJoin {
        name = bintools-unwrapped.name;
        paths = [ bintools-unwrapped bintools.passthru.bintools ];
      };
    });
  overrideBintools = stdenv: bintools:
    overrideCC stdenv (stdenv.cc.override { inherit bintools; });
  prefix = if stdenv.hostPlatform != stdenv.targetPlatform then
    "${stdenv.targetPlatform.config}-"
  else
    "";
  moldBintoolsUnwrapped = runCommand "mold-bintools-${mold.version}" { } ''
    mkdir -p $out/bin
    for prog in ${mold}/bin/*; do
      ln -s $prog $out/bin/${prefix}$(basename $prog)
    done
    ln -s ${mold}/bin/mold $out/bin/${prefix}ld
  '';
  myBintools = overrideBintoolsUnwrapped bintools moldBintoolsUnwrapped;
  myStdenv = overrideBintools stdenv myBintools;
in myStdenv
