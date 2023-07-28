{ pkgs, ... } @ args:
with pkgs;
let
  prune = import ./configs/prune.nix;
  nixos = import ./configs/nixos.nix;
  hardened = import ./configs/hardened.nix;
  docker = import ./configs/docker.nix;
  mesh = import ./configs/mesh.nix;
  media = import ./configs/media.nix;
in
buildLinux (args // rec {
  version = "5.15.92-hardened1";
  modDirVersion = version;

  nativeBuildInputs = [openssl ssh];
  defconfig = "mpfs_defconfig";

  kernelPatches = [
  ];

  autoModules = false;
  #extraConfig = prune + hardened + docker + mesh + media + nixos;
  extraConfig = prune + hardened + docker + mesh + media + nixos +
  ''
  EXTRA_FIRMWARE "ath10k/QCA6174/hw3.0/board-2.bin ath10k/QCA6174/hw3.0/firmware-6.bin ath10k/QCA988X/hw2.0/board.bin ath10k/QCA988X/hw2.0/firmware-4.bin ath10k/QCA988X/hw2.0/firmware-5.bin regulatory.db regulatory.db.p7s"
  EXTRA_FIRMWARE_DIR "${pkgs.ath10k-firmware}/lib/firmware"
  '';

  src = fetchGit {
    url = "ssh://git@github.com/tiiuae/tc_linux.git";
    rev = "9263d02a0883cf0deb012225ce1ccaabfd93fa9a";
    ref = "tc-saluki-5.15-sec";
  };

} // (args.argsOverride or { }))
