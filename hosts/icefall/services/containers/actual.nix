{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    "actual" = {
      image = "docker.io/actualbudget/actual-server:latest-alpine";
      ports = [ "127.0.0.1:5006:5006" ];
      volumes = [ "/var/lib/actual:/data" ];
    };
  };
}
