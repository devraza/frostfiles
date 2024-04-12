{
  virtualisation.oci-containers.containers = {
    "mautrix-signal" = {
      image = "dock.mau.dev/mautrix/signal:00f58da3d54e5056082dba3cdc70d59f790a3194-amd64";
      volumes = [
        "/var/lib/mautrix-signal:/data"
      ];
      ports = [
        "29328:29328"
      ];
    };
  };
}
