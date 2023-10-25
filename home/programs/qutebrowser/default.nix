{
  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile ./config.py;
  };

  xdg.configFile."qutebrowser/quickmarks".source = ./quickmarks;
}
