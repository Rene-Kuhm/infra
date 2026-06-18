{ inputs, lib, pkgs, ... }: {
  perSystem = { pkgs, self', ... }:
    let
      mkShell = pkgs.mkShell {
        name = "infra-shell";
        packages = with pkgs; [
          # Core tooling
          git
          gh
          nix
          nixfmt-rfc-style
          deadnix
          statix

          # Secrets
          sops
          age
          ssh-to-age

          # SSH
          openssh

          # Inspection
          nvd
          nix-diff
          nix-tree

          # Verification
          attic-client
        ];

        shellHook = ''
          echo "🏛️ TecnoSquire infra shell"
          echo ""
          echo "Available commands:"
          echo "  nix flake check            # Verify everything builds"
          echo "  nix build .#tecsnosquire   # Build NixOS config"
          echo "  deploy-rs .#tecsnosquire   # Deploy to server"
          echo "  sops secrets/secrets.yaml  # Edit encrypted secrets"
          echo ""
        '';
      };
    in
    {
      devShells = {
        default = mkShell;
      };
    };
}