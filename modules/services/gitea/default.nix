{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.gitea;
in
{
  options.services.gitea = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Gitea git hosting";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;

      settings = {
        server = {
          DOMAIN = "git.tsq.lan";
          ROOT_URL = "https://git.tsq.lan/";
          HTTP_PORT = 3000;
          SSH_DOMAIN = "git.tsq.lan";
          SSH_PORT = 22;
          LFS_OBJECTS_PATH = "/var/lib/gitea/lfs";
          OFFLINE_MODE = false;
        };

        database = {
          DB_TYPE = "sqlite3";
          PATH = "/var/lib/gitea/data/gitea.db";
        };

        service = {
          DISABLE_REGISTRATION = false;
          ENABLE_NOTIFY_MAIL = false;
        };
      };

      # Use postgres if available
      # database = {
      #   type = "postgres";
      #   host = "localhost";
      #   name = "gitea";
      #   user = "gitea";
      #   passwordFile = config.sops.secrets."gitea/db_password".path;
      # };
    };

    # State in impermanence-persisted location
    services.gitea.stateDir = "/var/lib/gitea";

    # Open firewall
    networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}