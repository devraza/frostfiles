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
    };
  };
}
