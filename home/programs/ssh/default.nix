{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "icefall" = {
        compression = true;
        identityFile = "~/.ssh/id_ed25519";
        host = "Icefall";
        hostname = "icefall.netbird.cloud";
        port = 6513;
      };
    };
  };
}
