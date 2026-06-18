{ pkgs }: {
  # Custom packages for TecnoSquire
  hello = pkgs.callPackage ./hello.nix { };
}