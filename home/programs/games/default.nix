{
  pkgs,
  hostName,
  inputs,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then with pkgs; [
    steam
    lutris # library manager

    wineWowPackages.staging
    (inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable.override rec {
      wine = wineWowPackages.staging;
      wine-discord-ipc-bridge = gamePkgs.wine-discord-ipc-bridge.override {inherit wine;};
    })
  ]
  else with pkgs; [];
}
