{ config, pkgs, lib, inputs, ... }: 
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
      tor-browser # tor browser, obviously
      foliate # e-book reader
      inkscape # svg editor
      jellyfin-media-player # media player
      kooha # screen recorder
      element-desktop # chat
      vesktop # discord

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
      brightnessctl # dim the damn colours!
      imv # image viewer
      ani-cli # anime from the terminal
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      eza # modern 'ls' replacement
      ripgrep # modern 'grep' replacement
      ouch # painless compression/decompression
      bottom # system 'top'
      wishlist # SSH directory
      inputs.vaporise.packages.${pkgs.system}.default # `rm` alternative
      inputs.bunbun.packages.${pkgs.system}.default # system fetch

      # Productivity
      zathura # PDF/EPUB/... file viewer
      thunderbird # e-mail
      libreoffice # FOSS Office suite!
      anki-bin # nice flashcards
      obsidian # notes
      furtherance # time tracker

      # Screenshotting
      grim # screenshots
      slurp # also screenshots

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gopass # password manager
      gnupg # GnuPG

      # System/Wayland
      libnotify # notification library
      gammastep # eye control
      swaylock-effects # wayland screen locker
      xdg-utils # utilties for the XDG desktop standard
      hyprpicker # color picker
      wl-clipboard # wayland clipboard

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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
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

  # Secret service
  services.gnome-keyring.enable = true;

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts
  ];
}
