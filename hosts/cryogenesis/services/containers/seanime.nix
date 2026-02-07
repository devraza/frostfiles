{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "seanime" = {
        image = "umagistr/seanime:latest";
        volumes = [
          "/var/lib/seanime/config:/root/.config/Seanime"
          "/var/lib/seanime/downloads:/downloads"
          "/var/lib/seanime/anime:/anime"
        ];
        extraOptions = [
          "--network=host"
          "--pull=newer"
        ];
      };
    };
  };
}
