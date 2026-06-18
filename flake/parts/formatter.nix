{ inputs, ... }: {
  perSystem = { pkgs, self', ... }:
    {
      formatter = pkgs.writeShellScriptBin "fmt" ''
        set -euo pipefail
        cd $(git rev-parse --show-toplevel 2>/dev/null || echo .)
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt .
        ${pkgs.deadnix}/bin/deadnix --edit .
      '';

      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
      };
    };
}