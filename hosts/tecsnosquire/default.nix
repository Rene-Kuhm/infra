{ inputs, self, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
    ./disko.nix
    ./boot.nix
  ];
}