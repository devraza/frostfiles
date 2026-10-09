{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.mango = {
    enable = true;
    settings = {
      # Window effects
      blur = 1;
      blur_layer = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 5;
        num_passes = 2;
      };
      border_radius = 6;
      focused_opacity = 1.0;

      env = [
        "WLR_DRM_NO_ATOMIC,1"
      ];

      # Monitor configuration
      monitor_rule = [
        "name:eDP-1,width:1920,height:1200,refresh:60,x:0,y:0"
        "name:DP-1,width:2560,height:1440,refresh:320,x:1920,y:0,vrr:1,primary:1"
        "name:DP-2,width:2560,height:1440,refresh:320,x:1920,y:0,vrr:1,primary:1"
        "name:HDMI-A-1,width:1920,height:1080,refresh:70,x:4480,y:0,rr:1"
      ];
      layer_rule = [
        "no_blur:1,layer_name:selection"
      ];

      # Startup
      exec_once = [
        "noctalia" # system shell
	      "${pkgs.gammastep}/bin/gammastep -l 52.486244:-1.890401" # blue light filter
	      "emacs --daemon"
      ];

      # Mouse settings
      mouse_accel_speed = -0.55;
      mouse_accel_profile = 1;

      # Tearing for lower latency
      allow_tearing = 1;

      # Better movement/focus across monitors
      focus_cross_monitor = 1;
      exchange_cross_monitor = 1;

      # Keyboard settings
      repeat_rate = 25;
      repeat_delay = 300;
      xkb_rules_layout = "us";
      xkb_rules_options = "grp:alt_shift_toggle";

      # Trackpad settings
      trackpad_natural_scrolling = 1;

      # Animations
      animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_duration_open = 400;
      animation_duration_close = 800;
      animation_curve = {
        open = "0.46,1.0,0.29,1";
        close = "0.08,0.92,0,1";
      };

      # Theming
      border_px = 2;
      gap_inner_horizontal = 4;
      gap_inner_vertical = 4;
      gap_outer_horizontal = 12;
      gap_outer_vertical = 12;
      focus_color = "0x31748fff";
      border_color = "0x6e6a86ff";

      # Keybinds
      bind = [
        "SUPER,r,reload_config"
        "SUPER+SHIFT,c,killclient"
        "SUPER,w,togglefloating"
        "SUPER,f,togglefullscreen"
        "SUPER+SHIFT,p,spawn,noctalia msg session lock"

        "SUPER,h,focusdir,left"
        "SUPER,j,focusdir,down"
        "SUPER,k,focusdir,up"
        "SUPER,l,focusdir,right"

        "SUPER,1,view,1"
        "SUPER,2,view,2"
        "SUPER,3,view,3"
        "SUPER,4,view,4"
        "SUPER,5,view,5"
        "SUPER,6,view,6"
        "SUPER,7,view,7"
        "SUPER,8,view,8"
        "SUPER,9,view,9"

        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"
        "SUPER+SHIFT,6,tag,6"
        "SUPER+SHIFT,7,tag,7"
        "SUPER+SHIFT,8,tag,8"
        "SUPER+SHIFT,9,tag,9"

        "SUPER+SHIFT,h,move_client,left"
        "SUPER+SHIFT,j,move_client,down"
        "SUPER+SHIFT,k,move_client,up"
        "SUPER+SHIFT,l,move_client,right"

        "SUPER+SHIFT,a,spawn,noctalia msg screenshot-fullscreen"
        "SUPER+SHIFT,s,spawn,noctalia msg screenshot-region"

        "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
        "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
        "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
        "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
        "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"

        "SUPER,space,spawn,noctalia msg panel-toggle launcher"
        "SUPER+SHIFT,space,spawn,noctalia msg panel-toggle control-center"
        "SUPER,Return,spawn,sh -c 'alacritty msg create-window || alacritty'"
        "SUPER,e,spawn,emacsclient -c"
        "SUPER,b,spawn,firefox"
        "SUPER,d,spawn,sh -c 'alacritty msg create-window -e btm || alacritty -e btm'"
        "SUPER,a,spawn,sh -c 'alacritty msg create-window -e yazi || alacritty -e yazi'"
        "SUPER,m,spawn,noctalia msg plugin noctalia/screen_recorder:service all replay-save"
      ];

      # Disable and enable the laptop monitor based on lid
      switchbind = [
        "fold,spawn,${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --off"
        "unfold,spawn,${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --on"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
    };
  };

  # Place custom keyboard layout
  xdg.configFile."xkb/symbols".source = ../../../assets/symbols;
}
