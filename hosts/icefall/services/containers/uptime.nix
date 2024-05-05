{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "uptime-kuma" = {
        image = "louislam/uptime-kuma:1.23.13-alpine";
        volumes = [
          "/var/lib/uptime-kuma:/app/data"
        ];
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
