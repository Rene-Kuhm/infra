{ config, lib, pkgs, ... }:

{
  # SSH server: hardened config
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      MaxAuthTries = 3;
      MaxSessions = 5;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      AllowAgentForwarding = true;
      AllowTcpForwarding = true;
      GatewayPorts = "no";
      PermitEmptyPasswords = false;
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
      ];
    };

    # Open firewall for SSH
    openFirewall = true;

    # Banner
    banner = ''
      TecnoSquire NixOS server - Authorized access only.
      All activity is logged.
    '';
  };
}