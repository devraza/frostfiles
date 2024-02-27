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
    jdk18
  ]
  else with pkgs; [ ];
}
