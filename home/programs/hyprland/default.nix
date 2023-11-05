{ pkgs, hostName, ... }: {
  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    enable = true;
    settings = {
      # Set monitor stuff
      monitor = if (hostName != "avalanche")
      then [
        "HDMI-A-2,preferred,auto,auto"
        "HDMI-A-2,addreserved,0,0,40,0"
        "eDP-1,disable"
      ]
      else [
        "eDP-1,preferred,auto,auto"
        "eDP-1,addreserved,0,0,40,0"
      ];

      # Set cursor size
      "env" = "XCURSOR_SIZE,24";

      # Startup
      exec-once = [
        "hyprpaper -c ~/.config/hypr/hyprpaper.conf"
        "eww open bar"
        "gammastep -l 52.486244:-1.890401"
        "mako"
      ];
      
      # Input Configuration
      input = {
        # Keyboard Configuration
        kb_layout = "us";
        repeat_rate = 55;
        repeat_delay = 400;

        follow_mouse = 1;

        touchpad.natural_scroll = true;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      # General options
      general = {
        gaps_in = "4";
        gaps_out = "12";
        border_size = "2";
        "col.active_border" = if (hostName != "avalanche") then "rgba(7ee6aeff)" else "rgba(a292e8ff)" ;
        "col.inactive_border" = "rgba(242426ff)";

        # Set default layout
        layout = if (hostName != "avalanche") then "master" else "dwindle";
      };

      # Decoration
      decoration = {
        # Shadows
        drop_shadow = true;
        shadow_range = "10";
        "col.shadow" = "rgba(1a1a1add)";
      };

      # Animations
      animation = [
        "workspaces,1,2,default"
        "windows,1,3,default"
      ];

      # Master layouting
      master = {
        mfact = "0.43";
        orientation = "center";
        new_is_master = true;
      };

      # Gestures
      gestures = {
        workspace_swipe = false;
      };

      ### Keybinds ###
      "$mod" = "SUPER";

      bind = [
        # Applications
       "$mod, return, exec, alacritty"
        "$mod, a, exec, alacritty -e joshuto"
        "$mod, z, exec, alacritty -e ncmpcpp"
        "$mod, d, exec, alacritty -e btm"
        "$mod, e, exec, neovide"
        "$mod, b, exec, qutebrowser"
        "$mod, p, exec, hyprpicker | wl-copy"
        "$mod, space, exec, rofi -show drun"
        "$mod SHIFT, space, exec, rofi -show run"

        # Screenshots
        "$mod SHIFT, a, exec, hyprgrimblast --screen"
        "$mod SHIFT, s, exec, hyprgrimblast --area"

        # Layout
        "$mod, u, pseudo"
        "$mod, i, togglesplit"

        # Power
        "$mod CONTROL SHIFT, a, exec, sudo poweroff"
        "$mod CONTROL SHIFT, s, exec, sudo reboot"

        # MPD
        "ALT SHIFT, j, exec, hyprmpc --previous"
        "ALT SHIFT, k, exec, hyprmpc --next"
        "ALT SHIFT, l, exec, hyprmpc --toggle"

        # Volume
        "$mod CONTROL, j, exec, hyprpamixer --decrease"
        "$mod CONTROL, k, exec, hyprpamixer --increase"
        "$mod CONTROL, l, exec, hyprpamixer --toggle"

        # Generic Keybinds
        "$mod SHIFT, p, exec, waylock"
        "$mod, w, togglefloating"
        "$mod, f, fullscreen"
        "$mod SHIFT, c, killactive"
        "$mod SHIFT, q, exit"

        # Move Focus 
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move Windows
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Switch Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"

        # Move Active Window
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"

        # Scroll Through Existing Windows
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        # Move/Resize Windows
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Hyprpaper - wallpaper
  home.packages = [ pkgs.hyprpaper ];

  # Dynamic hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = if (hostName != "avalanche")
                                           then
                                           ''
                                             preload = ~/.config/hypr/wallpapers/cirno-nix.jpg
                                             wallpaper = HDMI-A-2,~/.config/hypr/wallpapers/cirno-nix.jpg
                                             unload = ~/.config/hypr/wallpapers/cirno-nix.jpg
                                           ''
                                           else 
                                           ''
                                             preload = ~/.config/hypr/wallpapers/reimu.png
                                             wallpaper = eDP-1,~/.config/hypr/wallpapers/reimu.png
                                             unload = ~/.config/hypr/wallpapers/reimu.png
                                           '';

  # Put the wallpapers into the correct folder
  xdg.configFile."hypr/wallpapers".source = ./wallpapers;
}
