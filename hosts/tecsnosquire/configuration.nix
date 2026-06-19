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
  # NOTE: lanzaboote (configured in boot.nix) replaces systemd-boot.
  # Do NOT enable boot.loader.systemd-boot or canTouchEfiVariables here.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # LUKS device is configured in modules/security/luks.nix (using /dev/sda2)

  # Filesystems are managed by disko (see ./disko.nix)
  # Manual fileSystems definitions removed - let disko handle them

  # Swap: managed by disko (see /dev/vg/swap in disko.nix, randomEncryption=true)
  # Do NOT add swapDevices here or it will conflict with disko's swap.

  # Server is headless - no display manager, no X11, no video drivers needed.
}