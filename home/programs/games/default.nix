{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam

      # Game Development
      # ...
  ]
  else with pkgs; [];
}
