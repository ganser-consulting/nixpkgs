{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "it87";
  version = "unstable-2026-07-24";

  # Original is no longer maintained.
  # This is the same upstream as the AUR uses.
  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    rev = "490f76f61900c163fac5328506c49969bd716dc6";
    hash = "sha256-f+Tbyapfz0zuD0CGmb3TucqVeSF6OJL9V5MBMlkHsbw=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  meta = {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/frankcrawford/it87";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
