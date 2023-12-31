{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam
      wineWowPackages.staging
      scanmem

      # Game Development
      # ...
  ]
  else with pkgs; [];
}
