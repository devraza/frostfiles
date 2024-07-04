{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "linkwarden" = {
      image = "ghcr.io/linkwarden/linkwarden:latest";
      ports = [ "127.0.0.1:9040:3000" ];
      dependsOn = [ "postgres" ];
      volumes = [ "/var/lib/linkwarden/data:/data/data" ];
      environmentFiles = [ "/var/lib/linkwarden/environment.env" ];
      extraOptions = [
        "--network=postgres"
        "--pull=newer"
      ];
    };
  };
}
