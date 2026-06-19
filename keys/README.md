# Lanzaboote PKI keys (Secure Boot) - sbctl format

**WARNING**: `db/db.key`, `PK/PK.key`, and `KEK/KEK.key` are **PRIVATE KEYS** used for Secure Boot. If these leak, an attacker can sign malicious bootloaders that pass Secure Boot validation.

## Structure (sbctl-compatible)

```
keys/
├── db/
│   ├── db.key   # PRIVATE - used to sign UKI
│   └── db.pem   # public cert for signing
├── KEK/
│   ├── KEK.key  # PRIVATE
│   └── KEK.pem  # public cert
└── PK/
    ├── PK.key   # PRIVATE
    └── PK.pem   # public cert
```

## How it's used

- `boot.lanzaboote.pkiBundle = ../../keys;` in `modules/security/secureboot.nix`
- `db/db.key` signs the UKI (Unified Kernel Image) at build time
- `PK` and `KEK` are enrolled in firmware on first boot via `sbctl enroll-keys`

## Security recommendations

- The repo is currently public on GitHub, which exposes the private keys
- **TODO**: rotate keys if repo was ever public with keys committed
- **TODO**: encrypt keys with sops or agenix, or move to a private repo

## First-boot enrollment

```bash
# Auto-enroll (recommended)
sbctl enroll-keys --microsoft
```

## Regeneration

```bash
rm -rf /var/lib/sbctl/keys
nix-shell -p sbctl --run "sbctl create-keys"
# Then copy /var/lib/sbctl/keys/* to this directory
```
