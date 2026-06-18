{ config, lib, pkgs, ... }:

{
  # Home Manager for 'tecnodespegue' user
  home-manager = {
    users.tecnodespegue = {
      imports = [
        ../../home/tecnodespegue
      ];
      home.stateVersion = "25.05";
      home.username = "tecnodespegue";
      home.homeDirectory = "/home/tecnodespegue";
    };

    # Use the nixpkgs from the flake
    useGlobalPkgs = false;
    useUserPackages = true;
  };
}