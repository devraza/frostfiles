{
  pkgs,
  pkgs-stable,
  hostName,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs; [
    lutris # library manager
    wineWowPackages.staging # windows compat
    osu-lazer # osu!lazer
    protonup-ng # install proton-ge
    jdk21 # java
    steam-run # FHS environment
  ]
  else with pkgs; [ ];
}
