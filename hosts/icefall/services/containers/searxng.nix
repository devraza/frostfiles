{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "searxng" = {
      image = "searxng/searxng:latest";
      environment = {
        SEARXNG_BASE_URL = "http://search.icefall/";
      };
      volumes = [ "/etc/searxng:/etc/searxng:rw" ];
      ports = [
        "127.0.0.1:8888:8080" # Port
      ];
      extraOptions = [
        "--pull=newer"
        "--dns=9.9.9.9"
      ];
    };
  };
}
