final: _prev: {
  uboot-icicle-kit = final.callPackage ./uboot { pkgs = final; targetBoard = "microchip_mpfs_icicle";};
}
