{
  virtualisation.oci-containers.containers = {
    "invidious" = {
      image = "quay.io/invidious/invidious:2024.04.26-eda7444";
      environment = {
        INVIDIOUS_CONFIG = ''
          port: 4202
          db:
            dbname: invidious
            user: kemal
            password: ***REMOVED***
            host: 127.0.0.1
            port: 5432
          check_tables: true
          https_only: false
          statistics_enabled: true
          hmac_key: "***REMOVED***"
        '';
        dependsOn = "invidious-db";
      };
      extraOptions = [ "--network=host" ];
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
        POSTGRES_PASSWORD = "***REMOVED***";
      };
      extraOptions = [ "--network=host" ];
    };
  };
}
