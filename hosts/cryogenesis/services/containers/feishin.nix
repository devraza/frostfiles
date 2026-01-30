{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "feishin" = {
        image = "ghcr.io/jeffvli/feishin:latest";
        environment = {
          SERVER_NAME = "Navi";
          SERVER_TYPE = "navidrome";
          ANALYTICS_DISABLED = "true";
          SERVER_URL = "https://navi.permafrost.gleeze.com";
        };
        ports = [ "127.0.0.1:9180:9180" ];
        extraOptions = [
          "--pull=newer"
          "--network=host"
        ];
      };
    };
  };
}
