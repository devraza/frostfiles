{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "uptime-kuma" = {
        image = "louislam/uptime-kuma:latest";
        environment = {
          UPTIME_KUMA_HOST = "0.0.0.0";
        };
        volumes = [ "/var/lib/uptime-kuma:/app/data" ];
        extraOptions = [
          "--network=host"
          "--pull=newer"
        ];
      };
    };
  };
}
