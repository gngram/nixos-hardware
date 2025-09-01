{
  lib,
  pkgs,
  buildArmTrustedFirmware,
  fetchgit,
  enable-tee ? true,
}:
with pkgs; let
  target-board = "imx8mp";
in
  buildArmTrustedFirmware rec {
    pname = "imx8mp-atf";
    platform = target-board;
    enableParallelBuilding = true;
    extraMeta.platforms = ["aarch64-linux"];

  src = fetchgit {
    url = "https://github.com/nxp-imx/imx-atf.git";
    rev = "6ddd57019494cabfca5065368349109c37f2cc9f";
    sha256 = "sha256-8+5kV6wHhwMYVA9aqn4fNRhvgOLsU9RlX3UL7edMM+A=";
  };
#(lib.optional (lib.versionAtLeast pkgs.binutils.version "2.39") "LDFLAGS=--no-warn-rwx-segments")
    extraMakeFlags = lib.concatLists [
      ["PLAT=${platform}" "IMX_BOOT_UART_BASE=0x30890000" "bl31" "SPD=opteed"]
    ];

    filesToInstall = ["build/${target-board}/release/bl31.bin"];
    
    
  meta = with lib; {
    homepage = "https://github.com/nxp-imx/imx-atf";
    description = "Reference implementation of secure world software for ARMv8-A";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ gngram ];
    platforms = [ "aarch64-linux" ];
  };
  
  }
