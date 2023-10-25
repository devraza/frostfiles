{ config, pkgs, inputs, hostName, ... }: {
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      steam # Steam
      mpv # media viewer
      gimp # photoshop but better
      tor-browser # tor browser, obviously
      foliate # e-book reader

      # Programming
      neovide # neovim GUI

      # Misc. CLI/TUI Tools
      glow # markdown renderer for the terminal
      brightnessctl # dim the damn colours!
      imv # image viewer
      ani-cli # anime from the terminal
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      eza # modern 'ls' replacement
      ripgrep # modern 'grep' replacement
      ouch # painless compression/decompression
      pamixer # pipewire manipulation
      bottom # system 'top'
      tiny # IRC client

      # Productivity
      thunderbird # e-mail
      localsend # a better airdrop
      libreoffice # FOSS Office suite!
      obsidian # notes!
      logseq # better notes (FOSS)

      # Screenshotting
      grim # screenshots
      slurp # also screenshots
      grimblast # also also screenshots

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gopass # password manager
      gnupg # GnuPG

      # System/Wayland
      libnotify # notification library
      gammastep # eye control
      waylock # wayland screen locker
      cachix # nix caches for stuff
      xdg-utils # utilties for the XDG desktop standard
      redshift # fix the damn colours!
      hyprpicker # color picker
      wl-clipboard # wayland clipboard

      # Fonts
      rounded-mgenplus # japanese font
      font-awesome # font AWESOME

      # From the flake
      # ...

      # Games
      inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "neovide";
    };
  };

  # Configure nixpkgs
  nixpkgs = {
    config = {
      allowUnfree = true; # Allow unfree packages
      # Allow some insecure packages
      permittedInsecurePackages = [
        # ...
      ];
    };
  };

  fonts.fontconfig.enable = true; # enable fontconfig

  # GTK configuration
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Iosevka Comfy";
      package = pkgs.iosevka-comfy.comfy;
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
