{ config, lib, pkgs, ... }:

{
  # Lanzaboote: signed UKI boot
  boot.lanzaboote.enable = true;

  # Console
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Kernel cmdline
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
  ];
}