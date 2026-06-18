{ pkgs }: {
  # Custom packages for TecnoSquire
  # Add custom derivations here

  hello = pkgs.callPackage ./hello.nix { };

  # More packages as needed
}