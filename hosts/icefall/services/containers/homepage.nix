{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "homepage" = {
        image = "ghcr.io/gethomepage/homepage:latest";
        volumes = [
          "/var/lib/homepage-dashboard:/app/config"
          "/mnt/codebreaker:/media"
        ];
        environment = {
          PORT = "8082";
          HOST = "127.0.0.1";
          HOMEPAGE_ALLOWED_HOSTS = "dash.permafrost.gleeze.com";
        };
        extraOptions = [
          "--network=host"
          "--pull=newer"
        ];
      };
    };
  };
}
