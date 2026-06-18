# infra — NixOS reproducible infrastructure

Monorepo NixOS para el server **TecnoSquire** (Positivo BGH VJF155F11UAR, i3-7100U, 10GB RAM).

## Stack

- **NixOS** unstable con `nixpkgs` pin estable
- **lanzaboote** + **Secure Boot** (UKI firmado)
- **LUKS** con passphrase al boot (sin TPM, hardware no soporta)
- **impermanence** (root efímero, persistimos solo lo declarado)
- **sops-nix** para secrets cifrados en repo
- **disko** para partitioning declarativo
- **deploy-rs** para deploys reproducibles
- **Attic** propio como binario cache privado
- **Home Manager** para dotfiles del usuario `insyd`
- **GitHub Actions CI** (flake check + build + push a Attic)

## Servicios por fase

| Fase | Servicios | RAM estimada |
|---|---|---|
| F0 (base) | NixOS + lanzaboote + LUKS + impermanence + Attic + AdGuard + Gitea + monitoring liviano | ~5GB |
| F1 | + Nextcloud + Home Assistant + Vaultwarden | +3GB |
| F2 (post-RAM) | + Jellyfin + Immich | +4GB |
| ❌ descartado | k3s/k8s lab (no entra con 10GB) | — |

## Estructura

```
.
├── flake.nix                    # flake raíz con inputs pineados
├── flake.lock                   # generado, NO se edita
├── hosts/
│   └── tecnosquire/
│       ├── default.nix
│       ├── configuration.nix
│       ├── hardware.nix
│       ├── disko.nix
│       └── boot.nix
├── modules/
│   ├── base/                    # base común
│   ├── security/                # secure boot, luks, sops
│   ├── impermanence/            # root efímero
│   ├── boot/                    # lanzaboote
│   ├── networking/              # tailscale, firewall
│   ├── storage/                 # attic, restic
│   └── services/                # un módulo por servicio
├── home/                        # home-manager (insyd)
├── packages/                    # derivations custom
├── overlays/                    # overlays de nixpkgs
├── secrets/                     # cifrado con sops
├── shells/                      # devshells reproducibles
├── checks/                      # nix flake check + VM tests
├── deploy/                      # deploy-rs config
├── .github/workflows/           # CI
└── docs/                        # recovery, restore tests
```

## Quickstart (desde otra máquina)

```bash
# Clonar
gh repo clone Rene-Kuhm/infra
cd infra

# Checkear todo
nix flake check

# Build del host (dry-run)
nix build .#nixosConfigurations.tecsnosquire.config.system.build.toplevel

# Deploy via nixos-anywhere (primera vez, desde Ubuntu target)
nix run github:numtide/nixos-anywhere -- \
  --flake .#tecsnosquire \
  --target-host root@tecnodespegue
```

## Recovery

Ver [`docs/recovery.md`](./docs/recovery.md).

## Filosofía

> "Mi sistema no está configurado. Mi sistema está especificado, construido, firmado, desplegado, verificado y recuperable."

Toda la config vive acá. Cambios vía PR. CI verifica reproducibilidad. Deploy-rs empuja a producción. Si algo explota, rollback a una generación anterior o `nix flake check` desde una laptop limpia.