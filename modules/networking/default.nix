{ config, lib, pkgs, ... }:

{
  imports = [
    ./tailscale.nix
  ];

  # Basic networking
  networking = {
    hostName = "TecnoSquire";
    domain = "tsq.lan";

    # Use NetworkManager for flexibility
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
      };

      # Connections handled by Tailscale mostly
      ensureProfiles = {
        profiles = {
          "ts0" = {
            connection.type = "tun";
            connection.permissions = [ "user:tecnodespegue" ];
          };
        };
      };
    };

    # Firewall already in base/firewall.nix
    # nftables.enable = true;
  };

  # Network time
  services.timesyncd.enable = true;
}