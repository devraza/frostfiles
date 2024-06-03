{ pkgs, ... }:
{
  # Serve file server
  systemd = {
    timers = {
      "backup" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "24m";
          OnUnitActiveSec = "24h";
          Unit = "backup.service";
        };
      };
    };
    services = {
      "startup" = {
        script = with pkgs; ''
          # Mount the disk
          [ -d /mnt/codebreaker/Documents ] || ${cryptsetup}/bin/cryptsetup -d /etc/codebreaker.key luksOpen /dev/sdb1 codebreaker
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
      "backup" = {
        script = with pkgs; ''
          # Run backup
          ${restic}/bin/restic --repo /var/lib/backup backup /mnt/codebreaker/Documents --exclude-file /var/lib/backup/exclude.txt -p /etc/backup.key
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "startup.service"
          "networkmanager.service"
        ];
      };
      "dufs" = {
        script = with pkgs; ''
          ${dufs}/bin/dufs -A -a devraza:Rl6KSSPbVHV0QHU1@/:rw -b 0.0.0.0 -p 8090 /mnt/codebreaker
        '';
        serviceConfig = {
          Type = "simple";
          User = "root";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "networkmanager.service"
          "startup.service"
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
  };
}
