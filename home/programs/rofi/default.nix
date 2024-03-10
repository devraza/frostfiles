{ pkgs, lib, hostName, ... }: {
  programs.rofi = {
    enable = true;
    font = "Iosevka Comfy 10.5";
    location = "center";
    terminal = "alacritty";
    theme = ./config/interface.rasi;
    extraConfig = {
      modi = "run,drun,calc";
      drun-display-format = " {name} ";
      disable-history = true;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      display-calc = " Calculator ";
      sidebar-mode = true;
    };
    package = pkgs.rofi-wayland.override {
      plugins = [
        (pkgs.rofi-calc.overrideAttrs (oldAttrs: { buildInputs = with pkgs; [
          rofi-wayland
          libqalculate
          glib
          cairo
        ]; }))
      ];
    };
  };
}
