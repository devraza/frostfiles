{
  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server:latest";
      ports = [ "127.0.0.1:9493:9493" ];
      environment = {
        DOMAIN = "https://vault.devraza.giize.com";
      };
      environmentFiles = [ "/var/lib/vaultwarden/config.env" ];
      volumes = [ "/var/lib/vaultwarden:/data" ];
      extraOptions = [ "--pull=newer" ];
    };
  };
}
