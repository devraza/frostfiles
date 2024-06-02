{
  virtualisation.oci-containers.containers = {
    "fireshare" = {
      image = "shaneisrael/fireshare:v1.2.20";
      ports = [
        "127.0.0.1:9039:80"
      ];
      volumes = [
        "/var/lib/fireshare/data:/data"
        "/var/lib/fireshare/processed:/processed"
        "/mnt/codebreaker/Media/Videos/Fireshare:/videos"
      ];
      environmentFiles = [
        "/var/lib/fireshare/environment.env"
      ];
    };
  };
}
