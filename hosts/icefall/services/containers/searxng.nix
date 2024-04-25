{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "searxng" = {
        image = "searxng/searxng:2024.4.24-e0214412f";
        environment = {
          SEARXNG_BASE_URL="http://localhost/";
        };
        volumes = [
          "/etc/searxng:/etc/searxng:rw"
        ];
        ports = [
          "127.0.0.1:8887:8080" # Port
        ];
      };
    };
  };
}
