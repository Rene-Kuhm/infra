{
  description =
    "NixOS reproducible infrastructure monorepo - TecnoSquire server";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake framework
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";

    # Home Manager (gestión de dotfiles del usuario)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS modules
    lanzaboote = {
      # v0.4.3 is compatible with nixpkgs 25.05 (v1.0.0 requires newer lib types)
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret management
    agenix.url = "github:ryantm/agenix";

    # Deploy
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Binary cache
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote installer
    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Formatting & pre-commit
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, flake-parts, flake-utils, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
        ./flake/parts/devshells.nix
        ./flake/parts/formatter.nix
        ./flake/parts/overlays.nix
        ./flake/parts/packages.nix
        ./flake/parts/checks.nix
        ./flake/parts/nixos.nix
        ./flake/parts/home.nix
        ./flake/parts/deploy.nix
        ./flake/parts/ci.nix
      ];

      flake = {
        # Default binary cache for faster builds (also our own Attic once up)
        substituters = [ "https://cache.nixos.org" ];

        # Public trusted keys
        trustedPublicKeys =
          [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      };
    };
}
