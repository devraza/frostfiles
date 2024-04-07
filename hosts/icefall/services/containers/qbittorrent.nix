let
  VERSION = "4.6.4-1";
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
        "6881:6881"
        "8080:8080"
      ];
      volumes = [
        "/mnt/codebreaker/Media/Torrents:/downloads"
        "/var/lib/qbittorrent:/config"
      ];
    };
  };
}
