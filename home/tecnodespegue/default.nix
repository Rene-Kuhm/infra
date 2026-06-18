{ config, lib, pkgs, ... }:

{
  imports = [
    ./cli.nix
    ./dev.nix
    ./zellij.nix
  ];

  # Home state version (must match NixOS)
  home.stateVersion = "25.05";

  # User info
  home.username = "tecnodespegue";
  home.homeDirectory = "/home/tecnodespegue";

  # Don't install fonts globally
  home.file = {
    # README for the home directory
    ".local/share/tecnodespegue/README.md".text = ''
      # TecnoSquire home directory

      This is a NixOS-managed home directory.
      All dotfiles are versioned in github.com/Rene-Kuhm/infra.
    '';
  };
}