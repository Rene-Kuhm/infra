{ config, lib, pkgs, ... }:

{
  # Users
  users.mutableUsers = false;

  # Main user (you)
  users.users.tecnodespegue = {
    isNormalUser = true;
    home = "/home/tecnodespegue";
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
      # Primary SSH key from Windows (codex@nix-enterprise-recovery)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGq8DWjO6xcdY4P7+DHUbnlHFst6AWzBHPf/IymZuUbP codex@nix-enterprise-recovery"
    ];
  };

  # Enable zsh at the NixOS level (home-manager also configures it for the user)
  # This is required because users.users.tecnodespegue.shell is set to zsh
  programs.zsh.enable = true;

  # Root password: disabled (only SSH key access)
  users.users.root.hashedPassword = "!";

  # Wheel group: passwordless sudo (wheelNeedsPassword = false does this)
  security.sudo.wheelNeedsPassword = false;
}