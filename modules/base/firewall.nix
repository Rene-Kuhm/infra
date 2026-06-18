{ config, lib, pkgs, ... }:

{
  # Firewall using nftables
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      80    # HTTP (will be reverse-proxied)
      443   # HTTPS (will be reverse-proxied)
      53    # DNS (AdGuard)
    ];
    allowedUDPPorts = [
      53    # DNS
      51820 # WireGuard (Tailscale)
    ];

    # Default deny
    logRefusedConnections = true;
    logRefusedPackets = true;

    # Allow Tailscale interface
    trustedInterfaces = [ "tailscale0" ];
  };
}