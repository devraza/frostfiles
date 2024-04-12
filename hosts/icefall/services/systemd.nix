{ pkgs, ... }:
{
  # Serve file server
  systemd = {
    services = {
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
        ];
      };
    };
  };
}
