{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.monitoring;
in
{
  options.services.monitoring = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Prometheus + Grafana + Loki monitoring stack";
    };
  };

  config = lib.mkIf cfg.enable {
    # Prometheus
    services.prometheus = {
      enable = true;
      port = 9090;
      globalConfig = {
        scrape_interval = "30s";
        evaluation_interval = "30s";
      };
      scrapeConfigs = [
        {
          job_name = "tecsnosquire";
          static_configs = [{
            targets = [ "localhost:9100" ];  # node_exporter
            labels = { alias = "tecsnosquire"; };
          }];
        }
      ];

      exporters = {
        node = {
          enable = true;
          port = 9100;
        };
      };

      retentionTime = "30d";
    };

    # Grafana
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3001;
        };
        security = {
          admin_user = "admin";
          # admin password via sops
        };
      };

      # Pre-provisioned dashboards
      provision = {
        enable = true;
        datasources = [
          {
            type = "prometheus";
            name = "Prometheus";
            url = "http://localhost:9090";
            isDefault = true;
          }
        ];
      };
    };

    # Loki + Promtail for logs
    services.loki = {
      enable = true;
      configuration = {
        server.http_listen_port = 3100;
      };
    };

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
        };
        clients = [{
          url = "http://localhost:3100/loki/api/v1/push";
        }];
        scrape_configs = [{
          job_name = "system";
          static_configs = [{
            targets = [ "localhost" ];
            labels = {
              job = "syslog";
              __path__ = "/var/log/*.log";
            };
          }];
        }];
      };
    };

    # Open firewall
    networking.firewall.allowedTCPPorts = [ 9090 3001 3100 9080 9100 ];
  };
}