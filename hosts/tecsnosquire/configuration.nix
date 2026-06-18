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

  # Filesystems (handled by disko)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };
  fileSystems."/persistent" = {
    device = "/dev/disk/by-label/persistent";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  # Swap file (10GB RAM needs swap)
  swapDevices = [ { device = "/var/lib/swapfile"; size = 4 * 1024; } ];

  # Video drivers for Kaby Lake (intel)
  services.xserver.videoDrivers = [ "intel" ];
}