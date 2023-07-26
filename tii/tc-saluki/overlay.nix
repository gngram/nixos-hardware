final: _prev: {
  uboot-icicle-kit = final.callPackage ./uboot { pkgs = final; targetBoard = "microchip_mpfs_icicle";};
  ath10k-firmware = final.callPackage ./firmwares/ath10k.nix {};
}
