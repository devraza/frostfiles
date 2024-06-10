{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "paperless-broker" = {
      image = "docker.io/library/redis:latest";
      volumes = [
        "/var/lib/paperless/redis:/data"
      ];
      extraOptions = [ "--network=paperless" "--pull=newer" "--ip=10.89.2.2" ];
    };
    "paperless" = {
      image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
      volumes = [
        "/var/lib/paperless/data:/usr/src/paperless/data"
        "/var/lib/paperless/media:/usr/src/paperless/media"
      ];
      dependsOn = [
        "broker"
      ];
      ports = [
        "127.0.0.1:10000:8000"
      ];
      environmentFiles = [
        "/var/lib/paperless/environment.env"
      ];
      environment = {
        PAPERLESS_REDIS = "redis://10.89.2.2:6379";
      };
      extraOptions = [ "--network=paperless" "--pull=newer" ];
    };
  };

  systemd.services."network-paperless" = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.podman}/bin/podman network exists paperless || ${pkgs.podman}/bin/podman network create paperless
    '';
  };
}
