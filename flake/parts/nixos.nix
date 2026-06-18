{ inputs, lib, self, ... }: {
  flake.nixosConfigurations = {
    tecnosquire = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # External flake modules
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        ../../hosts/tecsnosquire
      ];

      specialArgs = {
        inherit inputs self;
      };
    };
  };
}