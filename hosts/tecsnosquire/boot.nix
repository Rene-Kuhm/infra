{ config, lib, pkgs, ... }:

{
  # Lanzaboote: signed UKI boot
  # This replaces systemd-boot with signed Unified Kernel Images
  boot.loader.systemd-boot.enable = false;  # Lanzaboote replaces this
  boot.lanzaboote = {
    enable = true;
    # Will be set to true after first install (requires manual MOK enrollment)
    enableSecureBoot = true;
    pcrBanks = [ "sha256" ];
  };

  # Kernel: build UKI
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Console setup for Kaby Lake
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