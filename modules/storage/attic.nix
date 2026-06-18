{ config, lib, pkgs, ... }:

{
  # Attic: private Nix binary cache server
  # See: https://github.com/zhaofengli/attic
  services.atticd = {
    enable = true;
    settings = {
      listen = "[::]:8443";
      # TLS will be configured via reverse proxy (Caddy or nginx)
      # For now, listen on HTTP for testing
      # tls = { ... };

      # Storage
      storage = {
        type = "s3";
        region = "us-east-1";
        bucket = "attic-cache";
        endpoint = "http://localhost:3900";
        # credentials via env
        accessKeyId = "garage";
        secretAccessKeyFile = "/run/atticd/garage-secret";
      };

      # Database
      database.url = "postgres://attic:attic@localhost:5432/attic";
    };

    # Use a separate user for the service
    user = "atticd";
    group = "atticd";

    # Open firewall
    openFirewall = true;
    firewallPort = 8443;
  };

  # Open firewall for cache endpoint
  networking.firewall.allowedTCPPorts = [ 8443 ];

  # Local chunk cache
  environment.systemPackages = [ pkgs.attic-client ];
}