{ pkgs, ... }:
{
  home.packages = [ pkgs.vesktop ]; # Add the vesktop package

  xdg.configFile."VencordDesktop/VencordDesktop/themes/hazakura.css".source = ./hazakura.css;
}
