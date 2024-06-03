{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "homepage" = {
        image = "ghcr.io/gethomepage/homepage:latest";
        ports = [
          "127.0.0.1:8082:8082"
        ];
        volumes = [
          "/var/lib/homepage-dashboard:/app/config"
          "/mnt/codebreaker:/media"
        ];
        environment = {
          PORT = "8082";
        };
        extraOptions = [ "--pull=newer" ];
      };
    };
  };
}
