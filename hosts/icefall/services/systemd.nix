{ pkgs, ... }:
{
  # Serve file server
  systemd.services = {
    "startup" = {
      script = with pkgs; ''
        # Mount the disk
        [ -d /mnt/codebreaker/Documents ] || ${btrfs-progs}/bin/btrfs device scan --all-devices
        [ -d /mnt/codebreaker/Documents ] || ${mount}/bin/mount /dev/disk/by-label/codebreaker /mnt/codebreaker

        # Restart headscale after some time
        [ -d /mnt/codebreaker/Documents ] || sleep 600
        [ -d /mnt/codebreaker/Documents ] || systemctl restart headscale
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
      after = [
        "networkmanager.service"
      ];
    };
    "podman-qbittorrent-nox" = {
      after = [
        "networkmanager.service"
        "startup.service"
      ];
    };
    "calibre-web" = {
      after = [
        "startup.service"
      ];
    };
  };
}
