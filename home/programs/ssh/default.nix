{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "icefall" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "Icefall";
        hostname = "100.64.0.2";
        port = 6513;
      };
    };
  };

  home.packages = [
    pkgs.wishlist
  ];
}
