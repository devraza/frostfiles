{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "postgres" = {
      image = "docker.io/library/postgres:16.4-alpine";
      volumes = [
        "/var/lib/postgres/data:/var/lib/postgresql/data"
      ];
      environmentFiles = [ "/var/lib/postgres/environment.env" ];
      extraOptions = [
        "--network=postgres"
        "--ip=10.89.0.2"
        "--pull=newer"
      ];
    };
  };

  systemd.services."network-postgres" = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.podman}/bin/podman network exists postgres || ${pkgs.podman}/bin/podman network create postgres
    '';
  };
}
