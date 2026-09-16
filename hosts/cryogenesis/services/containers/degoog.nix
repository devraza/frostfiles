{
  virtualisation.oci-containers = {
    containers.degoog = {
      image = "ghcr.io/degoog-org/degoog:latest";
      pull = "newer";
      volumes = [
        "/var/lib/degoog:/app/data"
      ];
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
