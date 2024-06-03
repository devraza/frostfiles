{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "miniflux" = {
      image = "miniflux/miniflux:2.1.3";
      ports = [
        "127.0.0.1:9050:8080"
      ];
      dependsOn = [
        "postgres"
      ];
      environmentFiles = [
        "/var/lib/miniflux.env"
      ];
      extraOptions = [ "--network=postgres" ];
    };
  };
}
