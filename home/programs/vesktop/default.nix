{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;
    vencord.themes = {
      system24 = "https://refact0r.github.io/system24/build/system24.css";
    };
    settings.enabledThemes = [ "system24.css" ];
  };
}
