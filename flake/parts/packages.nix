{ inputs, ... }: {
  perSystem = { pkgs, self', ... }:
    let
      packages = pkgs.callPackage ../packages { };
    in
    {
      packages = {
        default = packages.hello;
        inherit (packages)
          hello
          ;
      };
    };
}