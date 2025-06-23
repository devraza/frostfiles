{ pkgs, ... }:
{
  services.mpd = {
    enable = true;
    dataDir = "/home/devraza/Documents/Music/mpd/";
    musicDirectory = "/home/devraza/Documents/Music/";
    playlistDirectory = "/home/devraza/Documents/Music/mpd/playlists/";
  };

  home.packages = [ pkgs.ncmpcpp ];
  xdg.configFile."ncmpcpp/config".source = ./ncmpcpp.conf;
}
