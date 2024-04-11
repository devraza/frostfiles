{
  virtualisation.oci-containers.containers = {
    "actual" = {
      image = "docker.io/actualbudget/actual-server:24.4.0-alpine";
      ports = [
        "5006:5006"
      ];
      volumes = [
        "/var/lib/actual:/data"
      ];
    };
  };
}
