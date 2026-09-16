{ pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    # Load settings from settings.toml file made within Noctalia
    settings = ./settings.toml;
  };

  home.packages = with pkgs; [
    libqalculate
  ];
}
