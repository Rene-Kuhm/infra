{ config, lib, pkgs, ... }:

{
  # Tailscale: secure mesh networking
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";

    # Exit node / subnet routes: enable later if needed
    # extraUpFlags = [ "--advertise-exit-node" "--advertise-routes=192.168.68.0/24" ];

    # Auth key from secrets (after sops setup)
    # authKeyFile = config.sops.secrets."tailscale/auth_key".path;
  };

  # Open firewall for Tailscale
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}