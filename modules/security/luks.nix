{ config, lib, pkgs, ... }:

{
  # LUKS / dm-crypt configuration
  # Note: disko.nix handles the actual disk encryption setup

  # Ensure cryptsetup is available in initrd
  boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" ];

  # Required for LUKS unlock at boot
  boot.initrd.luks.devices = {
    primary = {
      device = "/dev/disk/by-uuid/CHANGE-ME";  # Set automatically by disko
      allowDiscards = true;
      bypassWorkqueues = true;
      # No TPM available on Positivo BGH VJF155F11UAR
      # We rely on passphrase entry at boot
    };
  };
}