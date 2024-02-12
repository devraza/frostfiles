{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam
      lutris # library manager

      wineWowPackages.staging
  ]
  else with pkgs; [];
}
