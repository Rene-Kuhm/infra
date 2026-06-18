{ config, lib, pkgs, ... }:

{
  imports = [
    ./users.nix
    ./ssh.nix
    ./firewall.nix
    ./locale.nix
    ./packages.nix
  ];

  # Allow unfree packages (some hardware drivers)
  nixpkgs.config.allowUnfree = true;

  # Allow unfree firmware (needed for WiFi, Intel microcode)
  hardware.enableRedistributableFirmware = true;

  # Default system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    tmux
    jq
    ripgrep
    fd
    bat
    tree
    zstd
    unzip
    p7zip
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Auto-garbage collect
    auto-optimise-store = true;

    # Allow substituters
    trusted-substituters = [
      "https://cache.nixos.org"
    ];

    # Substituter for our own Attic (configured in attic module)
    # trusted-public-keys = ...
  };

  # State version
  system.stateVersion = "25.05";
}