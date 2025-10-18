{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "icefall" = {
        compression = true;
        identityFile = "~/.ssh/id_ed25519";
        host = "icefall";
        hostname = "icefall";
        port = 6513;
      };
    };
  };
}
