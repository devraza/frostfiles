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
    wineWowPackages.staging # windows *games* compat
    osu-lazer-bin # osu!lazer binary
    protonup-ng # install proton-ge
    jdk17 # java
    dwarfs # fs
    steam-run # FHS environment
  ]
  else with pkgs; [ ];
}
