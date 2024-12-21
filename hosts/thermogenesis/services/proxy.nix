{
  services.tinyproxy = {
    enable = true;
    settings = {
      Listen = "0.0.0.0";
      Port = 7839;
    };
  };
}
