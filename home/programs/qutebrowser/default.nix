{ pkgs-stable, ... }:
{
  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile ./config.py;
    package = pkgs-stable.qutebrowser;
  };

  xdg.configFile."qutebrowser/quickmarks".source = ./quickmarks;
}
