{
  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server:1.30.5-alpine";
      environment = {
        DOMAIN = "https://vault.devraza.giize.com";
      };
      environmentFiles = [ "/var/lib/vaultwarden/config.env" ];
      volumes = [
        "/var/lib/vaultwarden:/data"
      ];
      extraOptions = [ "--network=host" ];
    };
  };
}
