{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "cinny" = {
      image = "ghcr.io/cinnyapp/cinny:latest";
      ports = [
        "127.0.0.1:10010:80"
      ];
    };
  };
}
