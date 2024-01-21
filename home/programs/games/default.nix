{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam
      lutris # library manager
  ]
  else with pkgs; [];
}
