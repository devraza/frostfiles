{ pkgs, config, hostName, ... }:

{
  programs.eww = {
    enable = true;
    configDir = if (hostName != "avalanche")
                then ./config/endogenesis
                else ./config/avalanche;
  };

  home.programs = [
    pamixer # eww dependency
  ];
}
