{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  imports = [
    ./modules.nix
  ];

  hardware = {
    deviceTree.name = "microchip/mpfs-icicle-kit.dtb";
    firmware = [
      (pkgs.callPackage ./firmwares/ath10k.nix {})
    ];
  };

  boot.extraModprobeConfig = lib.mkDefault ''
      options ath10k_core skip_otp=Y
    '';
}
