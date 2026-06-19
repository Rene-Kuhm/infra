{ config, lib, pkgs, ... }:

{
  # SOPS-nix: encrypted secrets in the repo
  # Requires:
  #   1. Generate age key pair: `age-keygen -o keys/tecnodespegue.key`
  #   2. Save public key to secrets/.sops.pub
  #   3. Configure recipients in secrets/.sops.yaml
  #   4. Create encrypted file: `sops secrets/secrets.yaml`

  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    # Default secrets accessible to all users
    defaultSopsFormat = "yaml";

    # Secrets per user
    secrets = {
      # Tailscale pre-auth key (auto-reconnect after install/reboot)
      "tailscale/auth_key" = {
        owner = "root";
        group = "root";
        mode = "0600";
      };

      # Attic credentials
      "attic/admin_token" = {
        owner = "root";
        group = "root";
      };

      # Gitea admin token
      "gitea/admin_token" = {
        owner = "root";
        group = "root";
      };

      # AdGuard password
      "adguard/admin_password" = {
        owner = "root";
        group = "root";
      };

      # NOTE: vaultwarden/admin_token and grafana/admin_password are reserved
      # for Fase 1/2 deploy. Add them to secrets.yaml when those services go live.
    };
  };

  # SOPS install
  environment.systemPackages = [ pkgs.sops ];
}