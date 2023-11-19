{
  pkgs,
  hostName,
  inputs,
  pkgs-stable,
  pkgs-vinegar,
  ...
}:
{
  home.packages = if (hostName == "endogenesis") then let
    gamePkgs = inputs.nix-gaming.packages.${pkgs.hostPlatform.system};
  in
    with pkgs; [
      # Override osu!stable wine version
      (gamePkgs.osu-stable.override rec {
        wine = pkgs.winePackages.staging;
        wine-discord-ipc-bridge = gamePkgs.wine-discord-ipc-bridge.override {inherit wine;}; # override the discord-ipc-bridge too
      })

      steam
      airshipper
    ]
  else
    with pkgs; [];
}
