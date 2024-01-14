{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam
      lutris # library manager

      # Game development/hacking
      scanmem
  ]
  else with pkgs; [];
}
