{ lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#151517";
          foreground = "#ece5ea";
        };
        normal = {
          black = "#5c5c61";
          red = "#f06969";
          green = "#91d65c";
          yellow = "#d9d564";
          blue = "#a292e8";
          magenta = "#e887bb";
          cyan = "#7ee6ae";
          white = "#ece5ea";
        };
        bright = {
          black = "#5c5c61";
          red = "#f06969";
          green = "#91d65c";
          yellow = "#d9d564";
          blue = "#a292e8";
          magenta = "#e887bb";
          cyan = "#7ee6ae";
          white = "#ece5ea";
        };
      };
      font = {
        normal = {
          family = "ZedMono Nerd Font";
        };
        size = 15.0;
      };
      window = {
        opacity = 0.9;
        padding = {
          x = 15;
          y = 15;
        };
      };
    };
  };
}
