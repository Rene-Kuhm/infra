{ config, lib, pkgs, ... }:

{
  # LUKS / dm-crypt configuration
  # Note: disko.nix creates the LUKS partition as /dev/sda2 (second partition on sda)
  # The actual LUKS UUID is unknown until install time, so we reference by partition path.

  # Ensure cryptsetup is available in initrd
  boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" ];

  # Required for LUKS unlock at boot
  # /dev/sda2 is the LUKS partition created by disko (sda1 = EFI, sda2 = LUKS container)
  boot.initrd.luks.devices = {
    primary = {
      device = "/dev/sda2";
      allowDiscards = true;
      bypassWorkqueues = true;
      # No TPM available on Positivo BGH VJF155F11UAR
      # We rely on passphrase entry at boot
    };
  };
}