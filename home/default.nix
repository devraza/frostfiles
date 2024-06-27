{ config, pkgs-stable, pkgs, lib, inputs, ... }: 
{
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      mpv # media viewer
      gimp # photoshop but better
      foliate # e-book reader
      inkscape # vector editor
      jellyfin-media-player # media player
      tor-browser # tor browser, obviously
      pkgs-stable.bitwarden # password manager
      blender # 3D
      krita # painting
      librewolf # alternate web browser
      transmission_4-gtk # torrenting
      monero-gui # moneor wallet GUI
      moonlight-qt # streaming

      # Misc. CLI/TUI Tools
      glxinfo # mesa stuff
      just # command runner
      appimage-run # simple, run appimages
      rclone # remote storage tool
      procs # ps replacement
      sd # sed replacement
      bat # cat replacement
      tokei # lines of code
      glow # markdown renderer for the terminal
      protonvpn-cli_2 # protonVPN
      brightnessctl # dim the damn colours!
      imv # image viewer
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
      thunderbird # e-mail
      libreoffice # FOSS Office suite!
      anki-bin # nice flashcards
      obsidian # notes
      furtherance # time tracker

      # Typst
      typst # a better LaTeX
      typstfmt # formatting for Typst
      typst-lsp # language server

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gnupg # GnuPG

      # System/Wayland
      wl-screenrec # screen recorder
      libnotify # notification library
      gammastep # eye control
      swaylock-effects # wayland screen locker
      xdg-utils # utilties for the XDG desktop standard
      hyprpicker # color picker
      wl-clipboard # wayland clipboard

      # Programming
      go
      gotools
      julia
      rustup
      lua
      python3

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
        autoconnect = ["qemu+ssh://devraza@icefall/system"];
        uris = ["qemu+ssh://devraza@icefall/system"];
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
