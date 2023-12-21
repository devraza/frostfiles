{ pkgs, config, hostName, ... }:

{
  programs.eww = {
    enable = true;
    configDir = if (hostName != "avalanche")
                then ./config
                else ./config_avalanche;
    package = pkgs.eww-wayland;
  };

  xdg.configFile."eww/eww.yuck".source = if (hostName != "avalanche")
                                         then ./config/endogenesis.yuck
                                         else ./config/avalanche.yuck;
  xdg.configFile."eww/eww.scss".source = ./config/eww.scss;
}
