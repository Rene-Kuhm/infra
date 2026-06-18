{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.nextcloud;
in
{
  options.services.nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;

      hostName = "cloud.tsq.lan";
      home = "/var/lib/nextcloud";

      # Use postgres for F1+
      database = {
        type = "postgresql";
        createLocally = true;
        user = "nextcloud";
      };

      # Use redis for caching (memory-saver for 10GB RAM)
      configureRedis = true;

      # SMTP (configure with sops secrets)
      # smtp = {
      #   host = "smtp.example.com";
      #   port = 587;
      #   encryption = "tls";
      #   fromAddress = "noreply@tsq.lan";
      #   user = "...";
      #   passwordFile = config.sops.secrets."smtp/password".path;
      # };

      # Nginx reverse proxy
      nginx = {
        enable = true;
        virtualHosts."cloud.tsq.lan" = {
          forceSSL = false;  # Will be configured later
          enableACME = false;
        };
      };

      # Apps
      enabledApps = {
        calendar = true;
        contacts = true;
        tasks = true;
        notes = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}