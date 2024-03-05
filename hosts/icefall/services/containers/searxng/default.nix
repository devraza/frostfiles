{ pkgs, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      "searxng" = {
        image = "searxng/searxng";
        environment = {
          SEARXNG_BASE_URL="${SEARXNG_HOSTNAME:-localhost}/";
        };
        volumes = [
          "./searxng:/etc/searxng:rw"
        ];
        ports = [
          "8888:8080" # Port
        ];
      };
    };
  };
}
