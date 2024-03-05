{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "pufferpanel" = {
        image = "pufferpanel/pufferpanel";
        environment = {
          PUFFER_LOGS = "/etc/pufferpanel/logs";
          PUFFER_PANEL_DATABASE_DIALECT = "sqlite3";
          PUFFER_PANEL_DATABASE_URL = "file:/etc/pufferpanel/pufferpanel.db?cache=shared";
          PUFFER_DAEMON_DATA_CACHE = "/var/lib/pufferpanel/cache";
          PUFFER_DAEMON_DATA_SERVERS = "/var/lib/pufferpanel/servers";
          PUFFER_DAEMON_DATA_MODULES = "/var/lib/pufferpanel/modules";
        };
        volumes = [
          "/etc/pufferpanel:/etc/pufferpanel"
          "/var/lib/pufferpanel:/var/lib/pufferpanel"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        ports = [
          "9291:8080" # Panel port
          "5657:5657" # SFTP port

          "39500:39500"
          "39400:39400"
          "39300:39300"
          "39200:39200"
          "39100:39100"
          "7777:7777"
          "7778:7778"
          "7779:7779"
        ];
      };
    };
  };
}
