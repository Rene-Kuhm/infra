{ inputs, ... }: {
  # Nix flake check - this module is imported by flake-parts automatically
  # It runs `nix flake check` against the entire flake

  imports = [
    ./vm-tests.nix
  ];

  # Custom checks go here
  # checks."tecsnosquire-build" = self.nixosConfigurations.tecsnosquire.config.system.build.toplevel;
}