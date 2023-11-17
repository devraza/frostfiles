{ pkgs, ... }:
{
  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile ./config.py;
    package = pkgs.qutebrowser;
  };

  xdg.configFile."qutebrowser/quickmarks".source = ./quickmarks;
}
