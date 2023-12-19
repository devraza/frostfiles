{
  services.soft-serve = {
    enable = true;
    settings = {
      name = "Devraza";
      log_format = "text";
      ssh = {
        listen_addr = ":2222";
        public_url = "ssh://devraza.duckdns.org:2222";
        max_timeout = 30;
        idle_timeout = 120;
      };
      stats.listen_addr = ":2222";
    };
  };
}
