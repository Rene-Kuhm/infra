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
  home.username = "insyd";
  home.homeDirectory = "/home/insyd";

  # Don't install fonts globally
  home.file = {
    # README for the home directory
    ".local/share/insyd/README.md".text = ''
      # TecnoSquire home directory

      This is a NixOS-managed home directory.
      All dotfiles are versioned in github.com/Rene-Kuhm/infra.
    '';
  };
}