{
  lib,
  fetchgit,
  enable-tee,
  stdenv,
  buildPackages,
  pkgsCross,
  openssl,
}:
let
  opteedflag = if enable-tee then "SPD=opteed" else "";
  target-board = "imx8mp";
in
stdenv.mkDerivation rec {
  pname = "imx8mp-atf";
  version = "lf-6.12.20-2.0.0";
  platform = target-board;
  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://github.com/nxp-imx/imx-atf.git";
    rev = "6ddd57019494cabfca5065368349109c37f2cc9f";
    sha256 = "sha256-8+5kV6wHhwMYVA9aqn4fNRhvgOLsU9RlX3UL7edMM+A=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # For Cortex-M0 firmware in RK3399
  nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

  buildInputs = [ openssl ];

  makeFlags = [
    "HOSTCC=$(CC_FOR_BUILD)"
    "M0_CROSS_COMPILE=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    # binutils 2.39 regression
    # `warning: /build/source/build/rk3399/release/bl31/bl31.elf has a LOAD segment with RWX permissions`
    # See also: https://developer.trustedfirmware.org/T996
    "LDFLAGS=-no-warn-rwx-segments"
    "PLAT=${platform}"
    "bl31"
    "${opteedflag}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp build/${target-board}/release/bl31.bin $out

    runHook postInstall
  '';

  hardeningDisable = [ "all" ];
  dontStrip = true;

  meta = with lib; {
    homepage = "https://github.com/nxp-imx/imx-atf";
    description = "Reference implementation of secure world software for ARMv8-A";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ gngram ];
    platforms = [ "aarch64-linux" ];
  };
}
