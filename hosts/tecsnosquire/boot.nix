{ config, lib, pkgs, ... }:

{
  # Lanzaboote: signed UKI boot
  # Note: enableSecureBoot is set to true AFTER first install + MOK enrollment
  boot.lanzaboote = {
    enable = true;
    pcrBanks = [ "sha256" ];
  };

  # Console setup
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Kernel cmdline
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
  ];
}