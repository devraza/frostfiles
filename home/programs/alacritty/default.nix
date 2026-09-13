{ lib, ... }:
{
  programs.alacritty = {
    enable = true;
    theme = "rose_pine";
    settings = {
      cursor = {
        style = {
          shape = "Beam";
        };
      };
      font = {
        normal = {
          family = "ZedMono Nerd Font";
        };
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
