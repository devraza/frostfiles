{ pkgs, ... }:
{
  # Serve file server
  systemd = {
    services = {
      "startup" = {
        script = with pkgs; ''
          # Restart headscale after some time
          sleep 600
          systemctl restart headscale
    
          # Mount the disk
          ${cryptsetup}/bin/cryptsetup -d /etc/codebreaker.key luksOpen /dev/sdb1 codebreaker
          ${mount}/bin/mount /dev/mapper/codebreaker /mnt/codebreaker
        '';
        serviceConfig = {
          type = "oneshot";
          user = "root";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "networkmanager.service"
        ];
      };
      "dufs" = {
        script = with pkgs; ''
          ${dufs}/bin/dufs -A -a devraza:Rl6KSSPbVHV0QHU1@/:rw -b 0.0.0.0 -p 8090 /mnt/codebreaker
        '';
        serviceConfig = {
          type = "simple";
          user = "root";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "networkmanager.service"
          "startup.service"
        ];
      };
      "kiwix" = {
        script = with pkgs; ''
          ${kiwix-tools}/bin/kiwix-serve --port=3920 /mnt/codebreaker/Documents/wikipedia_en_all_maxi_2024-01.zim
        '';
        serviceConfig = {
          type = "simple";
          user = "root";
        };
        wantedBy = [ "multi-user.target" ];
        after = [
          "networkmanager.service"
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
