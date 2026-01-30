{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "adguard" = {
        image = "adguard/adguardhome:latest";
        volumes = [
          "/var/lib/adguard/work:/opt/adguardhome/work"
          "/var/lib/adguard/conf:/opt/adguardhome/conf"
        ];
        extraOptions = [
          "--pull=newer"
          "--network=host"
        ];
      };
    };
  };
}
