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
  extraConfig = prune + hardened + docker + mesh + media + nixos;

  src = fetchGit {
    url = "ssh://git@github.com/tiiuae/tc_linux.git";
    rev = "9263d02a0883cf0deb012225ce1ccaabfd93fa9a";
    ref = "tc-saluki-5.15-sec";
  };

} // (args.argsOverride or { }))
