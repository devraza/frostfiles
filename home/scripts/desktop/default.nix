{ pkgs, lib, ... }:

let
   brightnessutil = pkgs.writeShellScriptBin "brightnessutil" ''
    #!/bin/bash

    round() {
      echo "if($1 % 10 < 5) $1 - ($1 % 10) else $1 + (10 - ($1 % 10))" | bc
    }

    # Brightness down
    brightness_down() {
      brightnessctl s 10%-
    }
    # Brightness up
    brightness_up() {
      brightnessctl s +10%
    }

    # Execute accordingly
    if [[ "$1" == "--decrease" ]]; then
    	brightness_down
    elif [[ "$1" == "--increase" ]]; then
    	brightness_up
    fi
  '';

  grimblastutil = pkgs.writeShellScriptBin "grimblastutil" ''
        #!/bin/bash

        # Screenshot area (only from the current monitor)
        screenshot_area() {
          ${pkgs.grim}/bin/grim -t png -l 4 -g "`${pkgs.slurp}/bin/slurp -b 151517cc -c a292e8cc -w 2`" - | ${pkgs.wl-clipboard}/bin/wl-copy
          notify-send --expire-time=2000 "Screenshot" "Area captured to clipboard"
        }
        # *Screen*shot
        screenshot() {
          ${pkgs.grim}/bin/grim -t png -l 4 -o $(hyprctl activeworkspace | awk 'FNR == 1 {print $7}' | sed 's/://g') - | ${pkgs.wl-clipboard}/bin/wl-copy
          notify-send --expire-time=2000 "Screenshot" "Screen captured to clipboard"
        }

        # Execute accordingly
        if [[ "$1" == "--area" ]]; then
    	    screenshot_area
        elif [[ "$1" == "--screen" ]]; then
    	    screenshot
        fi
  '';
in
{
  home.packages = [
    grimblastutil
    brightnessutil
  ];
}
