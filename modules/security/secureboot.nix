{ config, lib, pkgs, ... }:

{
  # Secure Boot configuration via lanzaboote
  # Note: This requires:
  #   1. Secure Boot enabled in BIOS (or enrolled via MOK after install)
  #   2. PKI keys generated and committed to keys/ directory
  #   3. After first install, enroll keys via:
  #        mokutil --import /var/lib/lanzaboote-installer/keys/PK.auth
  #        (or use sbctl enroll-keys)

  # PKI bundle for lanzaboote (signs the UKI)
  boot.lanzaboote.pkiBundle = ../../keys;

  # Required kernel parameters for secure boot
  boot.kernelParams = [
    "lockdown=integrity"
    "module.sig_enforce=1"
    "nokaslr"  # Disable KASLR for reproducibility (optional)
  ];

  # IMA (Integrity Measurement Architecture) - limited without TPM
  security.audit.enable = true;

  # Restrict kernel modules loading
  boot.kernel.sysctl."kernel.modules_disabled" = lib.mkForce 0;  # 0 = enabled

  # AppArmor
  security.apparmor.enable = true;
  security.apparmor.killUnconfinedConfinables = true;
}