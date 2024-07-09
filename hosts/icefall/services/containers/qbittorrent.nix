let
  VERSION = "latest";
in
{
  virtualisation.oci-containers.containers = {
    "qbittorrent-nox" = {
      ports = [ "127.0.0.1:8080:8080" ];
      environment = {
        QBT_EULA = "accept";
        QBT_VERSION = "${VERSION}";
        HOST = "127.0.0.1";
      };
      image = "qbittorrentofficial/qbittorrent-nox:${VERSION}";
      volumes = [
        "/mnt/codebreaker/Media/Torrents:/downloads"
        "/var/lib/qbittorrent:/config"
      ];
      extraOptions = [ "--pull=newer" "--dns=9.9.9.9" ];
    };
  };
}
