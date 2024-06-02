{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "linkwarden" = {
      image = "ghcr.io/linkwarden/linkwarden:v2.5.3";
      ports = [
        "127.0.0.1:9040:3000"
      ];
      dependsOn = [
        "postgres"
      ];
      volumes = [
        "/var/lib/linkwarden/data:/data/data"
      ];
      environmentFiles = [
        "/var/lib/linkwarden/environment.env"
      ];
      extraOptions = [ "--network=postgres" ];
    };
  };
}
