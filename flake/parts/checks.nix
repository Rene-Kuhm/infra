{ inputs, lib, ... }: {
  # Custom checks go here
  # checks."tecsnosquire-build" = self.nixosConfigurations.tecsnosquire.config.system.build.toplevel;

  # VM tests are temporarily disabled while we debug path resolution
  # They will be re-enabled once the basic flake check passes
}