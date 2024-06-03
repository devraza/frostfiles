let
  VERSION = "latest";
in
{
  virtualisation.oci-containers.containers = {
    "qbittorrent-nox" = {
      environment = {
        QBT_EULA = "accept";
        QBT_VERSION = "${VERSION}";
      };
      image = "qbittorrentofficial/qbittorrent-nox:${VERSION}";
      volumes = [
        "/mnt/codebreaker/Media/Torrents:/downloads"
        "/var/lib/qbittorrent:/config"
      ];
      extraOptions = [ "--network=host" "--pull=newer" ];
    };
  };
}
