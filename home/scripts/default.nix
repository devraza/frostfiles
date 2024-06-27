{ pkgs, ... }:
let
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
    dater
  ];
}
