{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "icefall" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "Icefall";
        hostname = "icefall.netbird.cloud";
        port = 6513;
      };
    };
  };

  home.packages = [
    pkgs.wishlist
  ];
}
