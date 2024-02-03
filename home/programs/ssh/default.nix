{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "icefall" = {
        host = "icefall";
        hostname = "icefall";
        port = 6513;
      };
      "local.icefall" = {
        host = "local.icefall";
        hostname = "192.168.1.246";
        port = 6513;
      };
    };
  };
}
