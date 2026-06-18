{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.jellyfin;
in
{
  options.services.jellyfin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;

      settings = {
        # Don't transcode (save RAM)
        # Direct play only
        EnableHardwareAcceleration = true;
        HardwareAccelerationType = "vaapi";
      };
    };

    # Enable VAAPI for Intel QuickSync
    hardware.graphics.extraPackages = with pkgs; [
      intel-vaapi-driver
      libva
      libvdpau-va-gl
    ];

    networking.firewall.allowedTCPPorts = [ 8096 ];
  };
}