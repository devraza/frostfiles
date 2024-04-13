{
  virtualisation.oci-containers.containers = {
    "mautrix-signal" = {
      image = "dock.mau.dev/mautrix/signal:5747acf9d7abe604494cb9c8df5a189fcea6db17-amd64";
      volumes = [
        "/var/lib/mautrix-signal:/data"
      ];
      ports = [
        "29328:29328"
      ];
    };
  };
}
