{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.adguard;
in
{
  options.services.adguard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AdGuard Home";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings = {
        # Bind to localhost only (Tailscale access)
        bind_host = "127.0.0.1";

        # Use upstream DNS (Cloudflare)
        upstream_dns = [
          "1.1.1.1"
          "1.0.0.1"
        ];

        # Bootstrap DNS
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];

        # Filtering
        filtering = {
          interval = 24;  # hours
        };
      };
    };

    # Open firewall for DNS
    networking.firewall.allowedTCPPorts = [ 53 3000 ];
    networking.firewall.allowedUDPPorts = [ 53 ];
  };
}