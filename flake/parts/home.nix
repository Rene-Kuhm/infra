{ inputs, lib, ... }: {
  flake.homeConfigurations = {
    # Standalone home-manager configuration for 'tecnodespegue' user (for development/testing)
    "tecnodespegue@tecsnosquire" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      modules = [
        ./../home/tecnodespegue
      ];
    };
  };
}