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
      # SSH keys for tecnodespegue user
      "ssh/tecnodespegue_key" = {
        neededForUsers = [ "tecnodespegue" ];
      };

      # Attic credentials
      "attic/admin_token" = {
        neededForUsers = [ "root" ];
      };

      # Gitea admin token
      "gitea/admin_token" = {
        neededForUsers = [ "root" ];
      };

      # AdGuard password
      "adguard/admin_password" = {
        neededForUsers = [ "root" ];
      };

      # Vaultwarden (if F1)
      "vaultwarden/admin_token" = {
        neededForUsers = [ "root" ];
      };

      # Monitoring admin
      "grafana/admin_password" = {
        neededForUsers = [ "root" ];
      };
    };
  };

  # SOPS install
  environment.systemPackages = [ pkgs.sops ];
}