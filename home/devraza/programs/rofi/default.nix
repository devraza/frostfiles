{ pkgs, lib, ... }: {
  programs.rofi = {
    enable = true;
    font = "Iosevka Comfy 10.5";
    location = "center";
    terminal = "alacritty";
    theme = ./config/hazakura.rasi;
    extraConfig = {
      modi = "run,drun";
      drun-display-format = " {name} ";
      disable-history = true;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      sidebar-mode = true;
    };
    package = pkgs.rofi-wayland-unwrapped;
  };
}
