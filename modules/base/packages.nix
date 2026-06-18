{ config, lib, pkgs, ... }:

{
  # Common system packages (already in base/default.nix but kept here for clarity)
  environment.systemPackages = with pkgs; [
    # Terminal
    alacritty
    kitty

    # System tools
    pciutils
    usbutils
    lshw
    dmidecode
    ethtool
    nettools
    bind  # dig, nslookup
    traceroute
    mtr

    # Disk tools
    parted
    gdisk
    smartmontools

    # Editors
    neovim
    vim

    # Search/find
    ripgrep
    fd
    fzf
    jq
    yq-go
  ];
}