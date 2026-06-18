# Recovery procedure for TecnoSquire

## Scenario 1: System won't boot after NixOS install

### If you have physical access to the notebook:

1. **Boot from NixOS installer USB**:
   ```bash
   # Download ISO
   nix download 'https://channels.nixos.org/nixos-25.05/latest-nixos-minimal-x86_64-linux.iso' --print-out-paths

   # Flash to USB
   dd if=path-to-iso of=/dev/sdX bs=4M status=progress
   sync
   ```

2. **Mount LUKS partition**:
   ```bash
   # Find the encrypted partition
   lsblk

   # Open LUKS
   cryptsetup open /dev/sda2 cryptroot
   # Enter passphrase

   # Mount root
   mount /dev/vg/root /mnt

   # Mount boot
   mount /dev/sda1 /mnt/boot

   # Chroot
   mount -t proc /proc /mnt/proc
   mount -t sysfs /sys /mnt/sys
   mount --rbind /dev /mnt/dev
   chroot /mnt /bin/bash
   ```

3. **Inspect / repair**:
   ```bash
   nixos-rebuild switch --flake /etc/nixos#tecsnosquire
   ```

4. **Exit and reboot**:
   ```bash
   exit
   umount -R /mnt
   reboot
   ```

### If you're remote (Tailscale SSH should work):

The system should still respond on Tailscale IP (100.118.211.108). Try:
```bash
ssh tecnosquire
```

If Tailscale daemon is broken, you'll need physical access.

## Scenario 2: Forgot LUKS passphrase

**There is no recovery. The data is gone.**

To prevent this:
- Store passphrase in a password manager (Bitwarden, KeePassXC, etc.)
- Keep paper backup in a safe place
- Use a USB keyfile as alternative unlock method

## Scenario 3: Want to completely rebuild

1. **Use nixos-anywhere** (works on any OS with SSH):
   ```bash
   nix run github:numtide/nixos-anywhere -- \
     --flake .#tecsnosquire \
     --target-host root@<IP> \
     --build-on-remote
   ```

2. **Or manually with disko**:
   - Boot NixOS installer USB
   - Run `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
       --mode disko /etc/nixos/hosts/tecsnosquire/disko.nix`

3. **Or completely fresh**:
   - Boot installer USB
   - Partition manually with LUKS
   - Install NixOS from there

## Scenario 4: Want to roll back to previous generation

```bash
sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
sudo nixos-rebuild switch --rollback
# Or
sudo /nix/var/nix/profiles/system-<N>-link/bin/switch-to-configuration switch
```

## Scenario 5: Accidentally wiped persistent data

If you ran a wipe but impermanence.nix is correctly configured, the
`/persistent` directory should be preserved. If not, restore from
restic backup:

```bash
# Mount LUKS
cryptsetup open /dev/sda2 cryptroot
mount /dev/vg/persist /mnt  # if you have a separate persist LV

# Restore from restic
RESTIC_REPOSITORY=s3:...  # or local
RESTIC_PASSWORD=$(cat /etc/secrets/restic-password)
restic restore latest --target /mnt/persistent --verify
```

## Scenario 6: Lost SSH access

If you have physical access:
1. Boot NixOS installer USB
2. Mount LUKS + root
3. Edit `/persistent/etc/ssh/sshd_config` to add `PasswordAuthentication yes`
4. Set a temporary root password: `passwd`
5. Reboot
6. SSH in with password, fix the config, redeploy

## Emergency contacts

- Tailscale admin console: https://login.tailscale.com/admin
- GitHub: https://github.com/Rene-Kuhm/infra (issues for this repo)
- NixOS Discourse: https://discourse.nixos.org

## Important files to know

- `flake.nix` — flake root
- `hosts/tecsnosquire/configuration.nix` — main host config
- `hosts/tecsnosquire/disko.nix` — partitioning scheme
- `hosts/tecsnosquire/boot.nix` — boot loader (lanzaboote)
- `modules/security/luks.nix` — LUKS configuration
- `modules/security/sops.nix` — secrets encryption
- `modules/impermanence/default.nix` — persistent paths
- `secrets/secrets.yaml` — encrypted secrets (requires age key to decrypt)
- `docs/recovery.md` — this file
- `docs/restore-test.md` — backup/restore procedures