{ pkgs, ... }:
{
  # Get rid of a useless service and by extension an error that appears every reboot
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # All the custom/modified SystemD services
  systemd.services = {
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

  # Various on-boot things
  systemd.services."startup" = {
    script = with pkgs; ''
      # Wait for the dependant services to settle
      sleep 10
      # Mount the disk
      ${mount}/bin/mount /dev/disk/by-uuid/5edfd73b-ffe5-4163-bed3-bb847c62b7fc /mnt/codebreaker
    '';
    serviceConfig = {
      type = "oneshot";
      user = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "networkmanager.service" ];
  };
}
