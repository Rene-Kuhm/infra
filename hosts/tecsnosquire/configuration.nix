{ config, pkgs, lib, inputs, self, ... }:

{
  imports = [
    ../../modules/base
    ../../modules/security
    ../../modules/impermanence
    ../../modules/boot
    ../../modules/networking
    ../../modules/storage
    ../../modules/users/insyd
    # Services (commented out by phase, uncomment as needed)
    # ../../modules/services/adguard
    # ../../modules/services/gitea
    # ../../modules/services/monitoring
    # ../../modules/services/nextcloud
    # ../../modules/services/homeassistant
    # ../../modules/services/vaultwarden
    # ../../modules/services/jellyfin
    # ../../modules/services/immich
  ];

  ##############################################################################
  # Hostname & basic system
  ##############################################################################
  networking.hostName = "TecnoSquire";
  networking.domain = "tsq.lan";

  # Time zone
  time.timeZone = "America/Buenos_Aires";

  # i18n
  i18n.defaultLocale = "es_AR.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "es_AR.UTF-8/UTF-8" ];

  ##############################################################################
  # Boot
  ##############################################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Initrd: need to include LUKS tools + TPM tools (for future-proof)
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm_mod" ];
  boot.initrd.luks.devices = {
    primary = {
      device = "/dev/disk/by-uuid/CHANGE-ME";  # Set by disko during install
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Required for Positivo BGH VJF155F11UAR
  services.xserver.videoDrivers = [ "intel" ];

  # File systems (handled by disko)
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/boot".device = "/dev/disk/by-label/EFI";
  fileSystems."/boot".neededForBoot = true;

  # Swap: use a swap file (we have only 10GB RAM)
  swapDevices = [
    { device = "/var/lib/swapfile"; size = 4 * 1024; }  # 4GB swap
  ];

  ##############################################################################
  # System state version (required by NixOS)
  ##############################################################################
  system.stateVersion = "25.05";
}