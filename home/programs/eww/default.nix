{
  pkgs,
  config,
  hostName,
  ...
}:

{
  programs.eww = {
    enable = true;
    configDir = ./config;
  };

  home.packages = [
    pkgs.pamixer # eww dependency
  ];
}
