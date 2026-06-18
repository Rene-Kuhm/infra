{ config, lib, pkgs, ... }:

{
  imports = [
    ./users.nix
    ./ssh.nix
    ./firewall.nix
    ./packages.nix
    # Home-manager config for the main user (imported here so it ships with base)
    ../users/tecnodespegue.nix
  ];

  # Allow unfree (some hardware drivers need it)
  nixpkgs.config.allowUnfree = true;

  # Distributable firmware (WiFi, Intel microcode, etc.)
  hardware.enableRedistributableFirmware = true;

  # Default packages
  environment.systemPackages = with pkgs; [
    vim git curl wget htop tmux jq ripgrep fd bat tree zstd unzip p7zip
    pciutils usbutils lshw dmidecode ethtool nettools bind traceroute mtr
    parted gptfdisk smartmontools neovim
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-substituters = [ "https://cache.nixos.org" ];
  };
}