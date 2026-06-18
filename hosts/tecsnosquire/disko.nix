{ config, lib, pkgs, ... }:

{
  # Disko: declarative partitioning with LUKS + LVM
  # Run during nixos-anywhere to wipe the disk and set up encryption
  disko.devices = {
    disk = {
      primary = {
        device = "/dev/sda";  # The 223GB SATA SSD
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            cryptroot = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                # Ask for passphrase twice during install
                # Can be replaced with keyfile later
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "vg";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg = {
        name = "vg";
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" "noatime" ];
            };
          };
          swap = {
            size = "4G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
        };
      };
    };
  };
}