{
  pkgs,
  pkgs-stable,
  hostName,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs; [
    steam # library
    lutris # library manager
    wineWowPackages.staging # windows *games* compat
    osu-lazer-bin # osu!lazer binary
    jdk17 # java
  ]
  else with pkgs; [ ];
}
