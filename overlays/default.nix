{ pkgs }: {
  # Default overlay: nothing yet, but available for custom packages
  default = final: prev: {
    # Add custom packages to nixpkgs here
    # e.g., myPkg = final.callPackage ../packages/myPkg { };
  };
}