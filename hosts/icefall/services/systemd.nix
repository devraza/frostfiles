{ pkgs, ... }:
{
  # Serve file server
  systemd.services = {
    "startup" = {
      script = with pkgs; ''
        # Mount the disk
        [ -d /mnt/codebreaker/Documents ] || ${mount}/bin/mount /dev/mapper/codebreaker /mnt/codebreaker

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
    "kiwix" = {
      script = with pkgs; ''
        ${kiwix-tools}/bin/kiwix-serve --address=127.0.0.1 --port=3920 /mnt/codebreaker/Documents/wikipedia_en_all_maxi_2024-01.zim
      '';
      serviceConfig = {
        Type = "simple";
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
      after = [
        "startup.service"
      ];
    };
    "podman-qbittorrent-nox" = {
      after = [
        "networkmanager.service"
        "startup.service"
      ];
    };
    "uptime-kuma" = {
      after = [
        "networkmanager.service"
        "startup.service"
      ];
    };
    "podman-fireshare" = {
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
