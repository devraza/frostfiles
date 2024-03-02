{
  pkgs,
  hostName,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs; [
    steam
    lutris # library manager

    wineWowPackages.staging
    temurin-jre-bin-17

    osu-lazer-bin # osu!lazer binary
  ]
  else with pkgs; [ ];
}
