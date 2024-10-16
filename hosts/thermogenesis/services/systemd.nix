{ pkgs, ... }:
{
  # Fix networking issue
  systemd.services = {
    "startup" = {
      script = with pkgs; ''
        # Connect to the internet
        sleep 30
        ${networkmanager}/bin/nmcli d disconnect enp9s0 && ${networkmanager}/bin/nmcli d connect enp9s0
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
