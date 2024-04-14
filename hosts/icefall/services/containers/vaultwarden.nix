{
  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server:1.30.5-alpine";
      environment = {
        DOMAIN = "https://vault.devraza.duckdns.org";
      };
      environmentFiles = [ "/var/lib/vaultwarden/config.env" ];
      ports = [
        "127.0.0.1:9493:80"
      ];
      volumes = [
        "/var/lib/vaultwarden:/data"
      ];
    };
  };
}
