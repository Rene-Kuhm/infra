{ config, lib, pkgs, ... }:

{
  # Restic: encrypted backups to S3-compatible storage or local
  services.restic.backups."tecsnosquire" = {
    enable = true;
    # Repository: configure after setting up remote storage
    # For now, use a local repository as a placeholder
    repository = "file:///persistent/backups/restic";

    # Backup paths
    paths = [
      "/persistent"
      "/etc/nixos"
    ];

    # Exclude noise
    exclude = [
      "*.tmp"
      "*.swp"
      "/persistent/backups"
      "/persistent/cache"
      "/persistent/tmp"
    ];

    # Schedule: daily at 03:00
    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };

    # Retention
    pruneOpts = [
      "--keep-daily 14"
      "--keep-weekly 8"
      "--keep-monthly 6"
      "--keep-yearly 3"
    ];

    # User
    user = "root";
  };

  # Open firewall for S3 backup endpoint
  # (Configure backup target via secrets)
}