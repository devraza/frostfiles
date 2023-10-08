{ pkgs, hostName, ... }: {
  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    enable = true;
    extraConfig = if (hostName != "avalanche")
                  then builtins.readFile ./hyprland.conf
                  else builtins.readFile ./hyprland_avalanche.conf;
  };

  # Hyprpaper - wallpaper
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper".source = if (hostName != "avalanche")
                                           then ./hyprpaper/hyprpaper.conf
                                           else ./hyprpaper/hyprpaper_avalanche.conf;
}
