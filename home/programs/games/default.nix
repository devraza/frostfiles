{
  pkgs,
  hostName,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
      steam
      osu-lazer-bin

      # Game development/hacking
      scanmem
  ]
  else with pkgs; [];
}
