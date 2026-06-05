{
  virtualisation.oci-containers = {
    containers.forgejo = {
      image = "codeberg.org/forgejo/forgejo:15-rootless";
      volumes = [
        "/var/lib/git:/var/lib/gitea"
      ];
      extraOptions = [
        "--network=host"
        "--pull=newer"
      ];
    };
  };
}
