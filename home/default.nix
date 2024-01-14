{ config, pkgs, ... }: 
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
      element-desktop # chat client
      firefox # other browser
      fragments # torrenting
      inkscape # svg editor

      # Programming
      neovim
      neovide # neovim GUI

      # Misc. CLI/TUI Tools
      rclone # remote strorage tool
      glow # markdown renderer for the terminal
      element # periodic table
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
      font-awesome # font AWESOME
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

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts
  ];
}
