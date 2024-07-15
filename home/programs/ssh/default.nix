{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "icefall" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "Icefall";
        hostname = "100.64.0.7";
        port = 6513;
      };
      "thermogenesis" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "Thermogenesis";
        hostname = "100.64.0.6";
        port = 6513;
      };
    };
  };

  home.packages = [
    pkgs.wishlist
  ];
}
