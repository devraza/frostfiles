{ pkgs, ... }:
{
  # Get rid of a useless service and by extension an error that appears every reboot
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # All the custom/modified SystemD services
  systemd.services = {
    "startup" = {
      script = with pkgs; ''
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
