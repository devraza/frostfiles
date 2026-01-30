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
        extraOptions = [
          "--pull=newer"
          "--network=host"
        ];
      };
    };
  };
}
