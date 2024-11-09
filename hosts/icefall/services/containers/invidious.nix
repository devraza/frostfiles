{
  virtualisation.oci-containers.containers = {
    "invidious" = {
      image = "quay.io/invidious/invidious:latest";
      ports = [ "127.0.0.1:4202:4202" ];
      dependsOn = [ "postgres" ];
      volumes = [ "/var/lib/invidious/config.yml:/invidious/config/config.yml" ];
      extraOptions = [
        "--network=postgres"
        "--pull=newer"
        "--dns=9.9.9.9"
      ];
    };

    "invidious-helper" = {
      image = "quay.io/invidious/inv-sig-helper:latest";
      cmd = ["--tcp" "0.0.0.0:12999"];
      dependsOn = [ "postgres" ];
      extraOptions = [
        "--network=postgres"
        "--pull=newer"
        "--dns=9.9.9.9"
        "--ip=10.89.1.3"
      ];
    };
  };
}
