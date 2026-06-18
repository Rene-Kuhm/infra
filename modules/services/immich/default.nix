{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.immich;
in
{
  options.services.immich = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      openFirewall = true;

      settings = {
        immich = {
          host = "127.0.0.1";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 2283 ];
  };
}