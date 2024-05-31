{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "homepage" = {
        image = "ghcr.io/gethomepage/homepage:v0.8.13";
        volumes = [
          "/var/lib/homepage-dashboard:/app/config"
          "/mnt/codebreaker:/media"
        ];
        environment = {
          PORT="8082";
        };
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
