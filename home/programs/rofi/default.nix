{ pkgs, lib, hostName, ... }: {
  programs.rofi = {
    enable = true;
    font = "Iosevka Comfy 10.5";
    location = "center";
    terminal = "alacritty";
    theme = if (hostName != "avalanche")
            then ./config/interface.rasi
            else ./config/interface_avalanche.rasi;
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
  home.packages = with pkgs; [
    rofi-calc
    rofi-mpd
  ];
}
