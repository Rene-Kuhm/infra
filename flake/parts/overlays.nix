{ inputs, lib, ... }: {
  flake.overlays = {
    # Default overlay: nothing yet, but available for custom packages
    default = final: prev: {
      # Example:
      # my-custom-pkg = final.callPackage ../packages/my-custom-pkg { };
    };

    # Unstable overlay: use this for specific packages that need newer versions
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
}