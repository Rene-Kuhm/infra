{ config, lib, pkgs, ... }:

{
  # Users
  users.mutableUsers = false;

  # Main user (you)
  users.users.insyd = {
    isNormalUser = true;
    home = "/home/insyd";
    description = "Rene Kuhm";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    uid = 1000;
    # SSH keys are managed via sops-nix (see secrets.nix)
    openssh.authorizedKeys.keys = [
      # Primary SSH key from Windows
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmAbVCB6UOX6KSn+UxdvFK8xQ8hdUk1PRFeDCZ6BwWHw insyd@tecnosquire"
    ];
  };

  # Root password: disabled (only SSH key access)
  users.users.root.hashedPassword = "!";

  # Wheel group: passwordless sudo
  security.sudo.wheelNeedsPassword = false;
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "ALL" ];
        }
      ];
    }
  ];
}