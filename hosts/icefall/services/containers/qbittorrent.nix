let
  VERSION = "4.6.4-2";
in
{
  virtualisation.oci-containers.containers = {
    "qbittorrent-nox" = {
      environment = {
        QBT_EULA = "accept";
        QBT_VERSION = "${VERSION}";
      };
      image = "qbittorrentofficial/qbittorrent-nox:${VERSION}";
      ports = [
        "127.0.0.1:8079:8080"
      ];
      volumes = [
        "/mnt/codebreaker/Media/Torrents:/downloads"
        "/var/lib/qbittorrent:/config"
      ];
    };
  };
}
