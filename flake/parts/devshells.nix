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
          nixpkgs-fmt
          deadnix
          statix

          # Deployment
          deploy-rs.packages.${pkgs.system}.deploy-rs
          nixos-rebuild  # Available via system path on NixOS

          # Secrets
          sops
          age

          # SSH
          openssh
          ssh-to-age  # Convert SSH keys to age keys for sops

          # Inspection
          nvd           # nix version diff
          nix-diff
          nix-tree

          # Verification
          attic-client  # once we set up Attic
        ];

        shellHook = ''
          echo "🏛️ TecnoSquire infra shell"
          echo "Available commands:"
          echo "  nix flake check            # Verify everything builds"
          echo "  deploy .#tecsnosquire      # Deploy to server"
          echo "  sops                      # Edit encrypted secrets"
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