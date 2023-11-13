{ pkgs, hostName, ... }:
{
  home.packages = if (hostName == "endogenesis" then 
    with pkgs; [
      osu-lazer-bin
      steam
    ];
}
