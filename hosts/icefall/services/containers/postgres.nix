{
  virtualisation.oci-containers.containers = {
    "postgres" = {
      image = "docker.io/library/postgres:16.3-alpine";
      volumes = [
        "/var/lib/postgres/data:/var/lib/postgresql/data"
        "/var/lib/invidious/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh"
      ];
      environmentFiles = [
        "/var/lib/postgres/environment.env"
      ];
      extraOptions = [ "--network=postgres" "--ip=10.89.0.2" ];
    };
  };
}
