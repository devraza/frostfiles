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
    (gaming.osu-stable.override rec {
      wine = wineWowPackages.staging;
      wine-discord-ipc-bridge = gaming.wine-discord-ipc-bridge.override {inherit wine;};
    })
  ]
  else with pkgs; [];
}
