{
  pkgs,
  hostName,
  inputs,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs;
  let gaming = inputs.nix-gaming.packages.${pkgs.hostPlatform.system}; in [
    steam
    lutris # library manager

    wineWowPackages.staging
    osu-lazer-bin

    temurin-jre-bin-17
  ]
  else with pkgs; [];
}
