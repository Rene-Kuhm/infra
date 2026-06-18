{ config, lib, pkgs, ... }:

{
  # Home Manager for 'insyd' user
  home-manager = {
    users.insyd = {
      imports = [
        ../../home/insyd
      ];
      home.stateVersion = "25.05";
      home.username = "insyd";
      home.homeDirectory = "/home/insyd";
    };

    # Use the nixpkgs from the flake
    useGlobalPkgs = false;
    useUserPackages = true;

    # Extra packages available to all users
    sharedModules = [
      ../../modules/stylix  # if used
    ];
  };
}