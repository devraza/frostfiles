{ pkgs, lib, ... }:

let
  active-workspace = pkgs.writeShellScriptBin "get-active-workspace" ''
    hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
      stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
  '';

in {
  home.packages = [
    active-workspace
    # Script dependencies
    pkgs.socat
    pkgs.jq
  ];
}
