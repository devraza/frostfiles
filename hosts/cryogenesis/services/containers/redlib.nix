{
  virtualisation.oci-containers = {
    containers.redlib = {
      image = "quay.io/redlib/redlib:latest";
      extraOptions = [
        "--network=host"
        "--pull=newer"
      ];
    };
  };
}
