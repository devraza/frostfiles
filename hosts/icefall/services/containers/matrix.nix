{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "homeserver" = {
      image = "matrixconduit/matrix-conduit:latest";
      volumes = [
        "/var/lib/matrix-conduit:/var/lib/matrix-conduit"
      ];
      environment = {
        CONDUIT_SERVER_NAME = "devraza.giize.com";
        CONDUIT_DATABASE_BACKEND = "rocksdb";
        CONDUIT_DATABASE_PATH = "/var/lib/matrix-conduit/";
        CONDUIT_PORT = "8029";
        CONDUIT_ALLOW_FEDERATION = "true";
        CONDUIT_ALLOW_REGISTRATION = "false";
        CONDUIT_ADDRESS = "0.0.0.0";
        CONDUIT_MAX_REQUEST_SIZE = "64000000";
        CONDUIT_ALLOW_CHECK_FOR_UPDATES = "true";
        CONDUIT_CONFIG = "";
      };
      extraOptions = [ "--network=host" "--pull=newer" ];
    };
    "mautrix-signal" = {
      image = "dock.mau.dev/mautrix/signal:latest";
      volumes = [
        "/var/lib/mautrix-signal:/data"
      ];
      extraOptions = [ "--network=host" "--pull=newer" ];
    };
    "mautrix-discord" = {
      image = "dock.mau.dev/mautrix/discord:latest";
      volumes = [
        "/var/lib/mautrix-discord:/data"
      ];
      extraOptions = [ "--network=host" "--pull=newer" ];
    };
  };
}
