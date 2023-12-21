{ pkgs, config, hostName, ... }:

{
  programs.eww = {
    enable = true;
    configDir = if (hostName != "avalanche")
                then ./config
                else ./config_avalanche;
    package = pkgs.eww-wayland;
  };

  xdg.configFile."eww/eww.scss".source = ./eww.scss;
}
