{
  virtualisation.oci-containers.containers = {
    "homeserver" = {
      image = "matrixconduit/matrix-conduit:7aa70e20306fccecaf56c63c67074c6e6593c5f9";
      ports = [
        "8029:6167"
      ];
      volumes = [
        "/var/lib/matrix-conduit:/var/lib/matrix-conduit"
      ];
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
