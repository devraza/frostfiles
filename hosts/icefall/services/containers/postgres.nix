{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "postgres" = {
      image = "docker.io/library/postgres:16.4-alpine";
      volumes = [
        "/var/lib/postgres/data:/var/lib/postgresql/data"
        "/var/lib/invidious/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh"
      ];
      environmentFiles = [ "/var/lib/postgres/environment.env" ];
      extraOptions = [
        "--network=postgres"
        "--ip=10.89.1.2"
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
