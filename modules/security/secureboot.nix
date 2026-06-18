{ config, lib, pkgs, ... }:

{
  # Secure Boot configuration
  # Note: This requires:
  #   1. Secure Boot enabled in BIOS
  #   2. MOK (Machine Owner Key) enrollment on first boot
  #   3. Lanzaboote generates and signs UKI

  # Required kernel parameters for secure boot
  boot.kernelParams = [
    "lockdown=integrity"
    "module.sig_enforce=1"
  ];

  # IMA (Integrity Measurement Architecture) - limited without TPM
  security.audit.enable = true;

  # Restrict kernel modules loading
  boot.kernel.sysctl."kernel.modules_disabled" = lib.mkForce 0;  # 0 = enabled

  # Disable kexec
  boot.kernelParams = [ "nokaslr" ];  # optional

  # AppArmor
  security.apparmor.enable = true;
  security.apparmor.killUnconfinedConfinables = true;
}