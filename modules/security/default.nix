{ config, lib, pkgs, ... }:

{
  imports = [
    ./secureboot.nix
    ./luks.nix
    ./sops.nix
  ];
}