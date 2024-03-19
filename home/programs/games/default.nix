{
  pkgs,
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

    aseprite # pixel editor
  ]
  else with pkgs; [ ];

  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (builtins.listToAttrs (builtins.map (jdk: {
    name = ".jdks/${jdk.version}";
    value = { source = jdk; };
  }) [ pkgs.openjdk17 pkgs.openjdk8 ] ));
}
