{
  pkgs,
  pkgs-stable,
  hostName,
  ...
}:
{
  home.packages =
  if (hostName == "endogenesis") then with pkgs; [
    steam
    lutris # library manager

    wineWowPackages.staging

    osu-lazer-bin # osu!lazer binary

    # Emulators
    pkgs-stable.citra-nightly # 3ds

    aseprite # pixel editor
  ]
  else with pkgs; [ ];

  xdg.desktopEntries = {
    "osu!" = {
      name = "osu!";
      exec = "osu!";
      noDisplay = true;
    };
    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
    "steam" = {
      name = "Steam";
      exec = "steam";
      noDisplay = true;
    };
  };
}
