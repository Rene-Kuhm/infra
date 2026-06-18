{ inputs, ... }: {
  perSystem = { pkgs, self', ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        programs.stdenvnox.enable = true;
      };

      formatter = pkgs.writeShellScriptBin "fmt" ''
        set -euo pipefail
        ${pkgs.treefmt}/bin/treefmt --fail-on-change "$@"
      '';

      # Pre-commit hooks (for development hygiene)
      pre-commit = {
        check.enable = true;
        # Uncomment to enable git hooks auto-install
        # settings.hooks.pre-commit.enable = true;
      };
    };
}