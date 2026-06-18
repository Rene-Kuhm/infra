{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.vaultwarden;
in
{
  options.services.vaultwarden = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      # Domain for the Bitwarden API
      domain = "https://vault.tsq.lan";

      # Use file-based config + env vars
      config = {
        SIGNUPS_ALLOWED = false;  # Disable public signups
        INVITATIONS_ALLOWED = true;
        SHOW_RAR = false;
      };

      # Env vars via sops
      environmentFile = config.sops.secrets."vaultwarden/env".path;
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts."vault.tsq.lan" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}