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
}
