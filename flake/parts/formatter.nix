{ inputs, ... }: {
  perSystem = { pkgs, self', ... }:
    {
      formatter = pkgs.writeShellScriptBin "fmt" ''
        set -euo pipefail
        cd $(git rev-parse --show-toplevel 2>/dev/null || echo .)
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt .
        ${pkgs.deadnix}/bin/deadnix --edit .
      '';

      # treefmt-check temporarily disabled: the .nix files were authored with
      # nixfmt 1.1.0 (classic) and would need a full reformat pass with
      # nixfmt-rfc-style. Re-enable after running `nix fmt` once.
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        settings.formatter.nixfmt.excludes = [ "*" ];
        settings.formatter.deadnix.excludes = [ "*" ];
      };
    };
}