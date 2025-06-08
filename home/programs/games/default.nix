{
  pkgs,
  pkgs-stable,
  pkgs-master,
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
    protonup-ng # install proton-ge
    jdk21 # java
    steam-run # FHS environment
    aseprite # spriting
    pkgs-master.ryujinx-greemdev
    (pkgs.tetrio-desktop.override{ withTetrioPlus = true; })
    vbam # GBA
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
