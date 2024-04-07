{
  virtualisation.oci-containers.containers = {
    "invidious" = {
      image = "quay.io/invidious/invidious";
      ports = [
        "4203:3000"
      ];
      environment = {
        INVIDIOUS_CONFIG = ''
          db:
            dbname: invidious
            user: kemal
            password: kemal
            host: invidious-db
            port: 5432
          check_tables: true
          https_only: false
          statistics_enabled: true
          hmac_key: "***REMOVED***"
        '';
        dependsOn = "invidious-db";
      };
    };
    "invidious-db" = {
      image = "docker.io/library/postgres";
      volumes = [
        "/var/lib/postgres/data:/var/lib/postgresql/data"
        "/var/lib/invidious/sql:/config/sql"
        "/var/lib/invidious/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh"
      ];
      environment = {
        POSTGRES_DB = "invidious";
        POSTGRES_USER = "kemal";
        POSTGRES_PASSWORD = "kemal";
      };
    };
  };
}
