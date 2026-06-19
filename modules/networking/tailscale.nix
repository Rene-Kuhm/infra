{ config, lib, pkgs, ... }:

{
  # Tailscale: secure mesh networking
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";

    # Exit node / subnet routes: enable later if needed
    # extraUpFlags = [ "--advertise-exit-node" "--advertise-routes=192.168.68.0/24" ];

    # Auth key from sops secrets (pre-auth key generated at https://login.tailscale.com/admin/settings/keys)
    # This is what lets Tailscale auto-auth after a fresh install without manual intervention
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
  };

  # Open firewall for Tailscale
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}