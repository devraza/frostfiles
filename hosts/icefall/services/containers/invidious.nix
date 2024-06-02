{
  virtualisation.oci-containers.containers = {
    "invidious" = {
      image = "quay.io/invidious/invidious:2024.04.26-eda7444";
      ports = [
        "127.0.0.1:4202:4202"
      ];
      dependsOn = [
        "postgres"
      ];
      volumes = [
        "/var/lib/invidious/config.yml:/invidious/config/config.yml"
      ];
      extraOptions = [ "--network=postgres" ];
    };
  };
}
