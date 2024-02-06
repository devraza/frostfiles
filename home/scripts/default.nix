{ pkgs, ... }:
let
  nas = pkgs.writeShellScriptBin "nas" ''
    #!/bin/bash

    # Mount NAS to pre-determined directory
    nas_automount() {
      rclone cmount codebreaker: ~/NAS --vfs-cache-mode full --daemon
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

  dater = pkgs.writeShellScriptBin "dater" ''
    #!/bin/bash

    DaySuffix() {
      case `date +%D` in
        1|21|31) echo "st";;
        2|22)    echo "nd";;
        3|23)    echo "rd";;
        *)       echo "th";;
      esac
    }
    date "+%A %e`DaySuffix` %B %Y"
  '';
in {
  # Import script directories
  imports = [
    ./hyprland
  ];

  home.packages = [
    nas
    dater
  ];
}
