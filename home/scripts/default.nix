let
  nas = pkgs.writeShellScriptBin "nas" ''
    #!/bin/bash

    # Mount NAS to pre-determined directory
    nas_automount() {
      mkdir -p ~/NAS && sshfs devraza@icefall:/mnt/codebreaker -p 6513 ~/NAS
    }

    # Execute
	  nas_automount
  '';
in {
  # Import script directories
  imports = [
    ./hyprland
    ./eww
  ];

  home.packages = [
    nas
    # Dependencies
    sshfs
  ];
}
