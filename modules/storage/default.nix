{ config, lib, pkgs, ... }:

{
  imports = [
    ./attic.nix
    ./restic.nix
  ];
}