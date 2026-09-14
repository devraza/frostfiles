{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "feishin" = {
        image = "ghcr.io/jeffvli/feishin:latest";
        pull = "newer";
        environment = {
          SERVER_NAME = "Navi";
          SERVER_TYPE = "navidrome";
          ANALYTICS_DISABLED = "true";
          SERVER_URL = "https://navi.permafrost.gleeze.com";
        };
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
