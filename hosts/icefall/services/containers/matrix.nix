{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "homeserver" = {
      image = "matrixconduit/matrix-conduit:v0.7.0";
      volumes = [
        "/var/lib/matrix-conduit:/var/lib/matrix-conduit"
      ];
      environment = {
        CONDUIT_SERVER_NAME = "devraza.duckdns.org";
        CONDUIT_DATABASE_BACKEND = "rocksdb";
        CONDUIT_DATABASE_PATH = "/var/lib/matrix-conduit/";
        CONDUIT_PORT = "8029";
        CONDUIT_ALLOW_FEDERATION = "true";
        CONDUIT_ALLOW_REGISTRATION = "true";
        CONDUIT_ADDRESS = "0.0.0.0";
        CONDUIT_MAX_REQUEST_SIZE = "64000000";
        CONDUIT_ALLOW_CHECK_FOR_UPDATES = "true";
        CONDUIT_CONFIG = "";
      };
      extraOptions = [
        "--network=host"
      ];
    };
    "mautrix-signal" = {
      image = "dock.mau.dev/mautrix/signal:703becae6de32e0f89611d492536883102814452-amd64";
      volumes = [
        "/var/lib/mautrix-signal:/data"
      ];
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
