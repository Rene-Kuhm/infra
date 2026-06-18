{ config, pkgs, lib, inputs, self, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./boot.nix
    # All base/security/impermanence/networking/storage/users/services modules
    # are imported by base/default.nix to avoid duplication.
    ../../modules/base
  ];

  # Hostname
  networking.hostName = "TecnoSquire";
  networking.domain = "tsq.lan";

  # Time zone
  time.timeZone = "America/Buenos_Aires";

  # Locale
  i18n.defaultLocale = "es_AR.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "es_AR.UTF-8/UTF-8" ];

  # NixOS system state version (only set here, NOT in base modules)
  system.stateVersion = "25.05";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.initrd.luks.devices = {
    primary = {
      device = "/dev/disk/by-uuid/CHANGE-ME";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  # Filesystems are managed by disko (see ./disko.nix)
  # Manual fileSystems definitions removed - let disko handle them

  # Swap file (10GB RAM needs swap)
  swapDevices = [ { device = "/var/lib/swapfile"; size = 4 * 1024; } ];

  # Video drivers for Kaby Lake (intel)
  services.xserver.videoDrivers = [ "intel" ];
}