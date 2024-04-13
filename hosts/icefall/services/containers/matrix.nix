{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "homeserver" = {
      ports = [
        "8029:6167"
      ];
      volumes = [
        "/var/lib/matrix-conduit:/var/lib/matrix-conduit"
      ];
      image = "matrix-conduit";
      imageFile = pkgs.dockerTools.buildImage {
        name = "matrix-conduit";
        fromImage = /var/lib/conduit-amd64.tar.gz;
        config = {
          Cmd = [ "/nix/store/w45flslxs0sbarnpkf757n3q1rk1iicc-conduit-0.7.0-alpha/bin/conduit" ];
          WorkingDir = "/srv/conduit";
        };
        tag = "latest";
      };
      environment = {
        CONDUIT_SERVER_NAME = "devraza.duckdns.org";
        CONDUIT_DATABASE_BACKEND = "rocksdb";
        CONDUIT_DATABASE_PATH = "/var/lib/matrix-conduit/";
        CONDUIT_PORT = "6167";
        CONDUIT_ALLOW_FEDERATION = "true";
        CONDUIT_ALLOW_REGISTRATION = "true";
        CONDUIT_ADDRESS = "0.0.0.0";
        CONDUIT_MAX_REQUEST_SIZE = "64000000";
        CONDUIT_ALLOW_CHECK_FOR_UPDATES = "true";
        CONDUIT_CONFIG = "";
      };
    };
  };
}
