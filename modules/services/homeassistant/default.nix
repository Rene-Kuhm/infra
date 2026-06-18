{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.homeassistant;
in
{
  options.services.homeassistant = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      package = pkgs.homeAssistant;
      configDir = "/var/lib/hass";
      config = {
        homeassistant = {
          name = "TecnoSquire";
          latitude = !lib.literalExpression "-34.6037";   # Buenos Aires
          longitude = !lib.literalExpression "-58.3816";
          elevation = 25;
          time_zone = "America/Buenos_Aires";
          country = "AR";
        };
        # Add integrations, devices, etc.
        # discovery = {};
        # frontend = {};
      };

      openFirewall = true;
    };
  };
}