{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "adguard" = {
        image = "adguard/adguardhome:latest";
        pull = "newer";
        volumes = [
          "/var/lib/adguard/work:/opt/adguardhome/work"
          "/var/lib/adguard/conf:/opt/adguardhome/conf"
        ];
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
