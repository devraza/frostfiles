{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "icefall" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "icefall";
        hostname = "icefall";
        port = 6513;
      };
      "local.icefall" = {
        identityFile = "~/.ssh/id_ed25519";
        host = "local.icefall";
        hostname = "192.168.1.246";
        port = 6513;
      };
    };
  };
}
