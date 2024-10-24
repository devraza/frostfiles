{
  config,
  pkgs-stable,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      jellyfin-media-player # jellyfin client
      signal-desktop # communications
      libreoffice # office suite
      krita # 2D art
      inkscape # vector editor
      blender # 3D
      firefox # web browser
      bitwarden # password manager

      # Misc. CLI/TUI Tools
      protonvpn-gui
      glxinfo # mesa stuff
      just # command runner
      appimage-run # simple, run appimages
      rclone # remote storage tool
      procs # ps replacement
      sd # sed replacement
      bat # cat replacement
      tokei # lines of code
      glow # markdown renderer for the terminal
      brightnessctl # dim the damn colours!
      ani-cli # anime from the terminal
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      eza # modern 'ls' replacement
      ripgrep # modern 'grep' replacement
      ouch # painless compression/decompression
      bottom # system 'top'
      rustscan # network mapper
      dogdns # alternative to 'dig'
      gnome-obfuscate # censor private information
      inputs.vaporise.packages.${pkgs.system}.default # `rm` alternative
      inputs.bunbun.packages.${pkgs.system}.default # system fetch

      # Productivity
      evince # document viewer
      obsidian # notes

      # Typst
      typst # a better LaTeX
      typstfmt # formatting for Typst

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gnupg # GnuPG

      # System/Wayland
      libnotify # notification library
      xdg-utils # utilties for the XDG desktop standard
      wl-clipboard # wayland clipboard

      # Programming
      go
      gotools
      julia
      rustup
      lua
      python3
      mono

      # Fonts
      rounded-mgenplus # japanese font
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "neovide";
    };
  };

  fonts.fontconfig.enable = true; # enable fontconfig

  # dconf configuration
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu+ssh://devraza@icefall/system" ];
        uris = [ "qemu+ssh://devraza@icefall/system" ];
      };
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "text/xml" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/qute" = [ "org.qutebrowser.qutebrowser.desktop" ];
    };
  };

  # Protonmail bridge
  systemd.user.services.hydroxide = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "hydroxide" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.hydroxide}/bin/hydroxide -disable-carddav serve
      ''}";
    };
  };

  # Fix the cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts
  ];
}
