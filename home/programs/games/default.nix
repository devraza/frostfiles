{
  pkgs,
  pkgs-stable,
  hostName,
  inputs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    lutris # library manager
    wineWowPackages.staging # windows compat
    (inputs.umu.packages.${pkgs.system}.umu.override { version = "${inputs.umu.shortRev}"; })
    protonup-ng # install proton-ge
    jdk21 # java
    osu-lazer-bin # osu!
    steam-run # FHS environment
    aseprite # spriting
    dotnetCorePackages.sdk_8_0_4xx # modding
  ];

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
