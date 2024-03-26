{ pkgs, lib, ... }:

let
  active-workspace = pkgs.writeShellScriptBin "get-active-workspace" ''
    hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
      stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
  '';

  hyprpamixer = pkgs.writeShellScriptBin "hyprpamixer" ''
    #!/bin/bash

    ID=$(cat /tmp/pamixer-volume-id)

    # Volume down
    volume_down() {
      pamixer -d 5 && notify-send --expire-time=1000 "Volume" "<span color='#78b9c4'>$(pamixer --get-volume-human | sed 's/m/M/')</span>" --replace-id "$ID" --print-id > /tmp/pamixer-volume-id
    }
    # Volume up
    volume_up() {
      pamixer -i 5 && notify-send --expire-time=1000 "Volume" "<span color='#78b9c4'>$(pamixer --get-volume-human | sed 's/m/M/')</span>" --replace-id "$ID" --print-id > /tmp/pamixer-volume-id
    }
    # Toggle volume muted status
    toggle_mute() {
      pamixer -t && notify-send --expire-time=1000 "Volume" "<span color='#78b9c4'>$(pamixer --get-volume-human | sed 's/m/M/')</span>" --replace-id "$ID" --print-id > /tmp/pamixer-volume-id
    }

    # Execute accordingly
    if [[ "$1" == "--decrease" ]]; then
	    volume_down
    elif [[ "$1" == "--increase" ]]; then
	    volume_up
    elif [[ "$1" == "--toggle" ]]; then
	    toggle_mute
    fi
  '';

  hyprgrimblast = pkgs.writeShellScriptBin "hyprgrimblast" ''
    #!/bin/bash

    # Screenshot area
    screenshot_area() {
      grim -g "`slurp -b 151517cc -c 242426ff -w 2`" - | wl-copy && notify-send --expire-time=1000 "Screenshot" "<span color='#78b9c4'>Area captured to clipboard</span>"
    }
    # *Screen*shot
    screenshot() {
      grim - | wl-copy && notify-send --expire-time=1000 "Screenshot" "<span color='#78b9c4'>Screen captured to clipboard</span>"
    }

    # Execute accordingly
    if [[ "$1" == "--area" ]]; then
	    screenshot_area
    elif [[ "$1" == "--screen" ]]; then
	    screenshot
    fi
  '';


in {
  home.packages = [
    active-workspace
    hyprpamixer
    hyprgrimblast
    # Script(s) dependencies
    pkgs.socat
    pkgs.jq
    pkgs.pamixer
  ];
}
