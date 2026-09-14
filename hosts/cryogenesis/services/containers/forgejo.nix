{
  virtualisation.oci-containers = {
    containers.forgejo = {
      image = "codeberg.org/forgejo/forgejo:16-rootless";
      pull = "newer";
      volumes = [
        "/var/lib/git:/var/lib/gitea"
      ];
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
