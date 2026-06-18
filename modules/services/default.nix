{ config, lib, pkgs, ... }:

{
  imports = [
    ./adguard
    ./gitea
    ./monitoring
    ./nextcloud
    ./homeassistant
    ./vaultwarden
    ./jellyfin
    ./immich
  ];

  # Feature flags for phased deployment
  options.services.tecsnosquire-services = {
    adguard.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable AdGuard Home DNS sinkhole";
    };

    gitea.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Gitea git hosting";
    };

    monitoring.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Prometheus + Grafana + Loki monitoring stack";
    };

    nextcloud.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nextcloud (Fase 1)";
    };

    homeassistant.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Home Assistant (Fase 1)";
    };

    vaultwarden.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Vaultwarden password manager (Fase 1)";
    };

    jellyfin.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Jellyfin media server (Fase 2 - requires RAM)";
    };

    immich.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Immich photo management (Fase 2 - requires RAM)";
    };
  };
}