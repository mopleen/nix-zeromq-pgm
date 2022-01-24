{ stdenv, fetchFromGitHub, perl, autoreconfHook, python3 }:
stdenv.mkDerivation {
  pname = "pgm";
  version = "5.3.128";
  src = fetchFromGitHub {
    owner = "steve-o";
    repo = "openpgm";
    rev = "release-5-3-128";
    sha256 = "0knwvwx9anpl35k0l9bsyfx0hvb26jd6qvxs6i6b2wi36d90l4lc";
  };
  patchPhase = ''
    mv openpgm/pgm/* .
    cp openpgm-5.2.pc.in openpgm-5.3.pc.in
  '';
  buildInputs = [ perl python3 autoreconfHook ];
}
