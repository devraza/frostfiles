{ pkgs, config, hostName, ... }:

{
  programs.eww = {
    enable = true;
    configDir = if (hostName != "avalanche")
                then ./config/endogenesis
                else ./config/avalanche;
  };

  home.packages = [
    pkgs.pamixer # eww dependency
  ];
}
