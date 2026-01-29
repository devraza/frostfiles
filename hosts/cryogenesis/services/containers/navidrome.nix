{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "navidrome" = {
        image = "deluan/navidrome:latest";
        volumes = [ "/var/lib/navidrome:/data" ];
        ports = [ "127.0.0.1:4533:4533" ];
        extraOptions = [ "--pull=newer" ];
      };
    };
  };
}
