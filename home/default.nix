{
  config,
  pkgs-stable,
  pkgs-master,
  pkgs,
  lib,
  inputs,
  ...
}:
{  
  home = {
    # Home configuration
    username = "devraza";
    pointerCursor.enable = true;
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      mpv # video
      evince # document viewer
      affinity-v3 # creative suite
      transmission_4-gtk # torrent
      kopuz # music player
      vesktop # Discord client
      rnote # handwritten notes
      libreoffice # office suite
      krita # 2D art
      foliate # e-book reader
      pkgs-stable.aseprite # spriting
      firefox # web browser
      anki-bin # flashcards

      # Misc. CLI/TUI Tools
      mesa-demos # mesa stuff
      just # command runner
      appimage-run # simple, run appimages
      procs # ps replacement
      sd # sed replacement
      bat # cat replacement
      tokei # lines of code
      yt-dlp # YT downloader
      ffmpeg # a lot
      ani-cli # anime from the terminal
      fd # find replacement
      steam-run # FHS environment
      dust # du replacement
      eza # ls replacement
      brightnessctl # monitor brightness
      ripgrep # grep replacement
      ouch # painless compression/decompression
      bunbun # CLI fetch tool
      bottom # system top
      rustscan # network mapper
      doggo # dig replacement
      gnome-obfuscate # censor private information
      inputs.vaporise.packages.${pkgs.stdenv.hostPlatform.system}.default # `rm` alternative

      # Typst
      typst # a better LaTeX
      typstyle # formatting for Typst

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gnupg # GnuPG

      # System/Wayland
      eog # image viewer
      libnotify # notification library
      xdg-utils # utilties for the XDG desktop standard
      wl-clipboard # wayland clipboard

      # Programming
      binutils
      gcc
      go
      gotools
      rustup
      devenv

      # Fonts
      rounded-mgenplus # jp font
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
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Fix the cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
  
  # Install custom fonts
  xdg.dataFile."fonts/cartograph".source = ../assets/fonts/cartograph;

  # Audio stuff
  services.easyeffects = {
    enable = true;
    preset = "Default";
  };

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts

    inputs.mangowm.hmModules.mango # MangoWM home-manager module 
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/webp" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
    };
  };
}
