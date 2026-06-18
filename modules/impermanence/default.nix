{ config, lib, pkgs, ... }:

{
  # Impermanence: ephemeral root, persistent data only in declared paths
  # This means: on every boot, / is wiped clean except for paths in environment.etc.persistent

  # Enable impermanence
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      # System state
      "/var/log"
      "/var/lib/systemd"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/var/lib/connman"
      "/var/lib/tailscale"
      "/var/lib/dhcpcd"

      # Databases (services)
      "/var/lib/postgresql"
      "/var/lib/redis"
      "/var/lib/gitea"
      "/var/lib/nextcloud"
      "/var/lib/homeassistant"
      "/var/lib/jellyfin"
      "/var/lib/immich"
      "/var/lib/vaultwarden"
      "/var/lib/attic"
      "/var/lib/grafana"
      "/var/lib/prometheus"

      # SSH
      "/etc/ssh"
      "/var/lib/sshd"

      # User home
      "/home/insyd"

      # Docker
      "/var/lib/docker"

      # Backups
      "/var/lib/restic"

      # Nix store persistence
      # (Nix store is on the root, but we can keep some state)
    ];

    files = [
      # Machine-id (important for various services)
      "/etc/machine-id"

      # SSH host keys
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ecdsa_key"
      "/etc/ssh/ssh_host_ecdsa_key.pub"

      # Sudoers
      "/etc/sudoers"
    ];
  };

  # Don't forget to add a bind mount for /persistent in the actual filesystem table
  # Or use impermanence's bind mount setup
  fileSystems."/persistent" = {
    device = "/dev/disk/by-label/persistent";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };
}