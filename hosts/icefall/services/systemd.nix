{ pkgs, ... }:
{
  # Serve file server
  systemd.services = {
    "startup" = {
      script = with pkgs; ''
        # Connect to the internet
        sleep 30
        ${networkmanager}/bin/nmcli d disconnect enp0s31f6 && ${networkmanager}/bin/nmcli d connect enp0s31f6

        # Mount the disk
        sleep 60
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
    };
    "podman-qbittorrent-nox" = {
      after = [
        "networkmanager.service"
        "startup.service"
      ];
    };
    "calibre-web" = {
      after = [ "startup.service" ];
    };
  };
}
