{ inputs, lib, ... }: {
  # CI-specific outputs that don't fit elsewhere
  flake = {
    # Nix flake check (run by GitHub Actions)
    checks.x86_64-linux.flake-check = inputs.nixpkgs-unstable.lib.runCommand "flake-check" { } ''
      ${inputs.nixpkgs-unstable.hello}/bin/hello
    '';
  };
}