# Backup and restore testing

## Why this matters

> "Backup sin restore test es wishful thinking." — Chris Richardson

This document covers how to verify that our restic backups actually work.

## Backup strategy

- **What**: `/persistent` (impermanence-persisted state) + `/etc/nixos`
- **Where**: Local file repo at `/persistent/backups/restic` (can be extended to S3/B2)
- **When**: Daily at 03:00 (configurable in `modules/storage/restic.nix`)
- **Retention**: 14 daily, 8 weekly, 6 monthly, 3 yearly

## Initial setup (one-time)

1. **Initialize restic repository**:
   ```bash
   # After NixOS is installed and restic service is running
   sudo restic -r /persistent/backups/restic init
   # Use the password stored in /etc/secrets/restic-password
   ```

2. **First backup** (don't wait for the timer):
   ```bash
   sudo systemctl start restic-backups-tecsnosquire
   sudo journalctl -u restic-backups-tecsnosquire -f
   ```

3. **Verify backup exists**:
   ```bash
   sudo restic -r /persistent/backups/restic snapshots
   ```

## Restore test procedure

**This must be done quarterly** (or after any major change).

### 1. Prepare test environment

```bash
# Create a test directory
sudo mkdir -p /tmp/restore-test

# List available snapshots
sudo restic -r /persistent/backups/restic snapshots
```

### 2. Restore latest snapshot to test location

```bash
# Restore to test directory (don't overwrite live data)
sudo restic -r /persistent/backups/restic restore latest \
    --target /tmp/restore-test \
    --verify
```

### 3. Verify integrity

```bash
# Check what was restored
ls -la /tmp/restore-test/

# Spot-check critical files
cat /tmp/restore-test/persistent/etc/ssh/ssh_host_ed25519_key.pub
cat /tmp/restore-test/persistent/var/lib/gitea/conf/app.ini | head

# Compare hashes with current state
diff <(find /persistent -type f -exec sha256sum {} \; 2>/dev/null | sort) \
     <(find /tmp/restore-test/persistent -type f -exec sha256sum {} \; 2>/dev/null | sed "s|/tmp/restore-test||" | sort)
```

### 4. Test specific services

```bash
# Database restore
sudo -u postgres pg_restore --list /tmp/restore-test/persistent/var/lib/postgresql/backup.sql
# (only works if you have a DB dump in the backup)

# Docker volumes (if backed up)
docker run --rm -v /tmp/restore-test/persistent/var/lib/docker:/data alpine ls /data

# Verify Gitea can start with restored data
sudo cp -r /tmp/restore-test/persistent/var/lib/gitea /tmp/gitea-test
sudo systemctl stop gitea
sudo -u gitea bash -c "GITEA_WORK_DIR=/tmp/gitea-test /nix/store/.../bin/gitea web --config /tmp/gitea-test/conf/app.ini --custom-path /tmp/gitea-test"
```

### 5. Cleanup

```bash
sudo rm -rf /tmp/restore-test /tmp/gitea-test
sudo systemctl start gitea
```

### 6. Document the test

Add an entry to `docs/restore-test-log.md`:

```markdown
## YYYY-MM-DD

- Snapshot used: latest (commit abc123)
- Files restored: X
- Hash matches: yes/no
- Service restored: gitea, postgres
- Issues found: ...
- Action items: ...
```

## Disaster recovery scenario

If the entire disk is lost:

1. **Boot NixOS installer USB**
2. **Open LUKS** with passphrase
3. **Mount root**
4. **Restore from restic** (if you have a remote repo):
   ```bash
   restic -r s3:s3.amazonaws.com/my-bucket restore latest --target /mnt
   ```
5. **Reinstall NixOS base** (the OS itself is reproducible from the flake):
   ```bash
   git clone https://github.com/Rene-Kuhm/infra.git
   cd infra
   nix run github:numtide/nixos-anywhere -- \
     --flake .#tecsnosquire \
     --target-host root@<IP>
   ```

## Automated backup verification

Consider adding this as a weekly systemd timer:

```nix
services.restic.backups."tecsnosquire-verification" = {
  enable = true;
  # Same repo as the main backup
  repository = "file:///persistent/backups/restic";

  # Run integrity check
  extraOptions = [ "check" ];

  timerConfig = {
    OnCalendar = "Sun 04:00";
    Persistent = true;
  };
};
```

## Monitoring backup health

Export to Prometheus:

```nix
services.prometheus.scrapeConfigs = [
  {
    job_name = "restic";
    static_configs = [{
      targets = [ "localhost:8001" ];  # if you run restic-server
    }];
  }
];
```

## Lessons learned

After every restore test, update this document with:
- Time taken
- Failures encountered
- Improvements to make