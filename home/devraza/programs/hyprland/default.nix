{ pkgs, ... }: {
  # Enable hyprland
  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  # Hyprpaper - wallpaper
  home.packages = with pkgs; [
    hyprpaper
  ];
  xdg.configFile."hypr/hyprpaper".source = ./hyprpaper;
}
