{
  pkgs,
  pkgs-stable,
  hostName,
  ...
}:
{
  home.packages = with pkgs; [
    lutris # library manager
    wineWowPackages.staging # windows compat
    protonup-ng # install proton-ge
    jdk21 # java
    steam
    steam-run # FHS environment
  ];
}
