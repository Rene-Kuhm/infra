# Lanzaboote PKI keys (Secure Boot)

**WARNING**: `db.key` is the **private key** used to sign the UKI (Unified Kernel Image). If this leaks, an attacker can sign malicious bootloaders that will pass Secure Boot validation.

## Files

| File | Public? | Purpose |
|---|---|---|
| `PK.auth` | yes | Platform Key (EFI signature list) |
| `PK.cer` | yes | Platform Key (DER certificate) |
| `KEK.auth` | yes | Key Exchange Key (EFI signature list) |
| `KEK.cer` | yes | Key Exchange Key (DER certificate) |
| `db.auth` | yes | Signature Database (EFI signature list) |
| `db.cer` | yes | Signature Database (DER certificate) |
| `db.key` | **PRIVATE** | Used by lanzaboote to sign the UKI |

## Security recommendations

- The repo is currently public on GitHub, which exposes `db.key`
- **TODO**: encrypt `db.key` with sops or agenix before making the repo public
- **TODO**: consider rotating keys if the repo was ever public with the key committed

## First-boot enrollment

After `nixos-anywhere` install, the keys need to be enrolled in firmware:

```bash
# Option 1: Use sbctl (modern, automatic)
sbctl enroll-keys --microsoft

# Option 2: Use mokutil (manual, requires MOK Manager)
mokutil --import /var/lib/lanzaboote/keys/PK.auth
# Reboot and confirm enrollment in MOK Manager
```

## Key generation

If you need to regenerate:

```bash
nix-shell -p efitools openssl --run '
  set -e
  cd /tmp/lanzakeys
  openssl req -new -x509 -newkey rsa:2048 -nodes -keyout PK.key -out PK.crt -days 3650 -subj "/CN=Platform Key/"
  openssl req -new -x509 -newkey rsa:2048 -nodes -keyout KEK.key -out KEK.crt -days 3650 -subj "/CN=Key Exchange Key/"
  openssl req -new -x509 -newkey rsa:2048 -nodes -keyout db.key -out db.crt -days 3650 -subj "/CN=Signature Database Key/"
  openssl x509 -in PK.crt  -outform DER -out PK.cer
  openssl x509 -in KEK.crt -outform DER -out KEK.cer
  openssl x509 -in db.crt  -outform DER -out db.cer
  GUID_PK="PK-$(cat /proc/sys/kernel/random/uuid)"
  GUID_KEK="KEK-$(cat /proc/sys/kernel/random/uuid)"
  GUID_db="db-$(cat /proc/sys/kernel/random/uuid)"
  cert-to-efi-sig-list -g "$GUID_PK"  PK.crt  PK.esl
  sign-efi-sig-list -t "2026-01-01" -k PK.key  -c PK.crt  PK  PK.esl  PK.auth
  cert-to-efi-sig-list -g "$GUID_KEK" KEK.crt KEK.esl
  sign-efi-sig-list -t "2026-01-01" -k KEK.key -c KEK.crt KEK KEK.esl KEK.auth
  cert-to-efi-sig-list -g "$GUID_db"  db.crt  db.esl
  sign-efi-sig-list -t "2026-01-01" -k db.key  -c db.crt  db  db.esl  db.auth
'
```
