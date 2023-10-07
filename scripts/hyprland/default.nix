{ pkgs, lib, ... }:

let
  active-workspace = pkgs.writeShellScriptBin "get-active-workspace" ''
    hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
      stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
  '';

  hyprmpc = pkgs.writeShellScriptBin "hyprmpc" ''
    #!/bin/bash

    ## Play the previous song in the playlist
    previous_song() {
  	  mpc -q prev && notify-send --expire-time=2000 "Now Playing" "<span color='#78b9c4'>$(getinfo --artist)</span> \n$(getinfo --song)"
    }
    ## Play the next song in the playlist
    next_song() {
  	  mpc -q next && notify-send --expire-time=2000 "Now Playing" "<span color='#78b9c4'>$(getinfo --artist)</span> \n$(getinfo --song)"
    }
    ## Pause the song
    toggle() {
	    mpc -q toggle && notify-send --expire-time=1000 "MPD" "<span color='#7ee6ae'>Toggled Playback!</span>"
    }

    ## Execute accordingly
    if [[ "$1" == "--previous" ]]; then
	    previous_song
    elif [[ "$1" == "--next" ]]; then
	    next_song
    elif [[ "$1" == "--toggle" ]]; then
	    toggle
    fi
  '';

in {
  home.packages = [
    active-workspace
    hyprmpc
    # Script(s) dependencies
    pkgs.socat
    pkgs.jq
    pkgs.mpc-cli
  ];
}
