{ pkgs, lib, ... }:

let
  grimblastutil = pkgs.writeShellScriptBin "grimblastutil" ''
        #!/bin/bash

        # Screenshot area (only from the current monitor)
        screenshot_area() {
          ${pkgs.grim}/bin/grim -t png -l 4 -g "`${pkgs.slurp}/bin/slurp -b 151517cc -c a292e8cc -w 2`" - | ${pkgs.wl-clipboard}/bin/wl-copy
          notify-send --expire-time=2000 "Screenshot" "Area captured to clipboard"
        }
        # *Screen*shot
        screenshot() {
          ${pkgs.grim}/bin/grim -t png -l 4 -o $(mmsg get focusing-client | ${pkgs.jq}/bin/jq -r ".monitor") - | ${pkgs.wl-clipboard}/bin/wl-copy
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
  ];
}
