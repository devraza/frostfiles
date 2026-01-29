{
  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server:latest";
      ports = [ "127.0.0.1:9493:80" ];
      environment = {
        DOMAIN = "https://vault.permafrost.giize.com";
      };
      environmentFiles = [ "/var/lib/vaultwarden/config.env" ];
      volumes = [ "/var/lib/vaultwarden:/data" ];
      extraOptions = [ "--pull=newer" ];
    };
  };
}
