{
  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server:1.30.5-alpine";
      ports = [
        "127.0.0.1:9493:9493"
      ];
      environment = {
        DOMAIN = "https://vault.devraza.giize.com";
      };
      environmentFiles = [ "/var/lib/vaultwarden/config.env" ];
      volumes = [
        "/var/lib/vaultwarden:/data"
      ];
    };
  };
}
