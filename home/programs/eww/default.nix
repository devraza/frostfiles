{ pkgs, config, hostName, ... }:

{
  programs.eww = {
    enable = true;
    configDir = ./config/endogenesis;
  };

  home.packages = [
    pkgs.pamixer # eww dependency
  ];
}
