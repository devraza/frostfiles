{ pkgs, ... }:
let
  nas = pkgs.writeShellScriptBin "nas" ''
    #!/bin/bash

    # Mount NAS to pre-determined directory
    nas_automount() {
      rclone mount codebreaker: ~/NAS --daemon
    }
    # Unmount NAS from pre-determined directory
    nas_autounmount() {
      umount ~/NAS
    }
    # Execute accordingly
    if [[ "$1" == "mount" ]]; then
	    nas_automount
    elif [[ "$1" == "unmount" ]]; then
	    nas_autounmount
    fi
  '';
in {
  # Import script directories
  imports = [
    ./hyprland
    ./eww
  ];

  home.packages = [
    nas
  ];
}
