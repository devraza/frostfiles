{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "miniflux" = {
      image = "miniflux/miniflux:latest";
      ports = [ "127.0.0.1:9050:8080" ];
      dependsOn = [ "postgres" ];
      environmentFiles = [ "/var/lib/miniflux.env" ];
      extraOptions = [
        "--network=postgres"
        "--pull=newer"
        "--dns=9.9.9.9"
      ];
    };
  };
}
