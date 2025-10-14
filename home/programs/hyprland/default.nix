{ pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      # Monitors
      monitor = [
        "eDP-1,preferred,auto-down,1" # laptop
        "HDMI-A-1,preferred,0x0,1" # ultrawide
        "DP-7,preferred,auto-left,1,transform,3" # vertical left
        "DP-8,preferred,auto-right,1" # right
      ];

      # Set cursor size
      "env" = "XCURSOR_SIZE,24";

      # Startup
      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "hyprctl setcursor Bibata-Modern-Classic 22" # set cursor
        "${pkgs.gammastep}/bin/gammastep -l 52.486244:-1.890401"
      ];

      # Input Configuration
      input = {
        # Keyboard Configuration
        kb_layout = "us";
        repeat_rate = 25;
        repeat_delay = 300;

        follow_mouse = 1; # windows follow the mouse cursor on move

        touchpad.natural_scroll = true;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      # General options
      general = {
        allow_tearing = true;
        gaps_in = "4";
        gaps_out = "12";
        border_size = "2";
        "col.active_border" = "rgba(f06969ff) rgba(7ee6aeff) 45deg";
        "col.inactive_border" = "rgba(242426ff)";
        layout = "dwindle";
      };

      # Plugin options
      plugin.split-monitor-workspaces.count = 8;

      # Decoration
      decoration = {
        inactive_opacity = "0.75";
        shadow = {
          enabled = true;
          color = "0xa0242426";
          render_power = "2";
          range = "12";
        };
      };

      layerrule = [
        "blur,rofi" # blur on rofi
      ];
      windowrulev2 = [
        "noblur, class:(eog)"
        "float, class:(udiskie)"
      ];

      # Animations
      animation = [
        "workspaces,1,2,default"
        "windows,1,3,default"
        "fade,1,3,default"
      ];

      # Master layouting
      master = {
        mfact = "0.43";
        orientation = "center";
      };

      # Miscellaneous
      misc = {
        vfr = true; # perf
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;

        enable_anr_dialog = false; # disable annoying 'not responding' popups
      };

      ### Keybinds ###
      "$mod" = "SUPER";

      bind = [
        # Applications
        "$mod, return, exec, alacritty msg create-window || alacritty"
        "$mod, a, exec, alacritty msg create-window -e yazi || alacritty -e yazi"
        "$mod, z, exec, tsukimi"
        "$mod, d, exec, alacritty msg create-window -e btm || alacritty -e btm"
        "$mod, e, exec, neovide --grid" # --grid to fix issue where it doesn't tile
        "$mod, b, exec, firefox"
        "$mod, space, exec, rofi -show drun"
        "$mod SHIFT, space, exec, rofi -show run"
        "$mod CONTROL, space, exec, rofi -show calc"

        # Screenshots
        "$mod SHIFT, a, exec, grimblastutil --screen"
        "$mod SHIFT, s, exec, grimblastutil --area"

        # Brightness
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s +10%"

        # Media keys
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Generic Keybinds
        "$mod, w, togglefloating"
        "$mod SHIFT, p, exec, hyprlock"
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
        "$mod, 1, split-workspace, 1"
        "$mod, 2, split-workspace, 2"
        "$mod, 3, split-workspace, 3"
        "$mod, 4, split-workspace, 4"
        "$mod, 5, split-workspace, 5"
        "$mod, 6, split-workspace, 6"
        "$mod, 7, split-workspace, 7"
        "$mod, 8, split-workspace, 8"

        # Move Active Window
        "$mod SHIFT, 1, split-movetoworkspacesilent, 1"
        "$mod SHIFT, 2, split-movetoworkspacesilent, 2"
        "$mod SHIFT, 3, split-movetoworkspacesilent, 3"
        "$mod SHIFT, 4, split-movetoworkspacesilent, 4"
        "$mod SHIFT, 5, split-movetoworkspacesilent, 5"
        "$mod SHIFT, 6, split-movetoworkspacesilent, 6"
        "$mod SHIFT, 7, split-movetoworkspacesilent, 7"
        "$mod SHIFT, 8, split-movetoworkspacesilent, 8"

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

  # Dynamic hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpapers/winterforest.jpg
    wallpaper = HDMI-A-1,~/.config/hypr/wallpapers/winterforest.jpg
    wallpaper = eDP-1,~/.config/hypr/wallpapers/winterforest.jpg
    wallpaper = DP-7,~/.config/hypr/wallpapers/winterforest.jpg
    wallpaper = DP-8,~/.config/hypr/wallpapers/winterforest.jpg
    splash = false
    ipc = off
  '';

  programs.hyprpanel.enable = true;

  # Put the wallpapers into the correct folder
  xdg.configFile."hypr/wallpapers".source = ../../../assets/wallpapers;

  # Lockscreen
  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ./hyprlock.conf;
  };
}
