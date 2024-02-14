{
  pkgs,
  hostName,
  inputs,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs;
  let gamePkgs = inputs.nix-gaming.packages.${pkgs.hostPlatform.system}; in [
    steam
    lutris # library manager

    wineWowPackages.staging
    (gamePkgs.osu-stable.override rec {
      wine = wineWowPackages.staging;
      wine-discord-ipc-bridge = gamePkgs.wine-discord-ipc-bridge.override {inherit wine;};
    })
  ]
  else with pkgs; [];
}
