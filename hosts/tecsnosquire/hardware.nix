{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Positivo BGH VJF155F11UAR - Intel Kaby Lake
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  # Enable important kernel modules
  boot.kernelModules = [ "kvm-intel" ];

  # Filesystem support (ZFS removed - not used; would require networking.hostId)
  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" "ntfs" "f2fs" ];

  # Networking (DHCP for now, will be overridden by networking module)
  networking.useDHCP = lib.mkDefault true;

  # Enable WiFi (Intel Wireless-AC 3168)
  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;

  # Hardware-specific packages
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}