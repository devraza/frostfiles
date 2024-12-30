{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "sonarr" = {
      image = "ghcr.io/linuxserver/sonarr:latest";
      environment = {
        "PUID" = "1000";
        "PGID" = "100";
      };
      volumes = [
        "/var/lib/sonarr/.config/NzbDrone:/config"
        "/mnt/codebreaker/Media/Anime:/tv"
        "/mnt/codebreaker/Media/Torrents:/downloads"
      ];
      extraOptions = [
        "--pull=newer"
        "--network=host"
      ];
    };
  };
}
