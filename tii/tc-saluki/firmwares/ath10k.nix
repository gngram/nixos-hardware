{ pkgs, ...}:
with pkgs;
stdenv.mkDerivation rec {
  name = "ath10k-firmware";

  src = fetchFromGitHub {
    owner = "codehub8";
    repo = "tc_firmware";
    rev = "fb4e32afc546a63bfb88b3b8107813f73f7c1d7b";
    sha256 = "sha256-ktKMslFZb57B9U+U5ibrsfGKb4sH2946TPxMGB4NU+o";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r ./ath10k $out/lib/firmware/
  '';
  }
