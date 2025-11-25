{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;
    vencord = {
      themes = {
        system24 = "@import url('https://refact0r.github.io/system24/build/system24.css');";
      };
      useSystem = true;
    };
    settings.enabledThemes = [ "system24.css" ];
  };
}
