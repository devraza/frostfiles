{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tiny
  ];
  xdg.configFile."tiny/config.yml".source = ./config.yml;
}
