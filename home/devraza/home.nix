{ config, pkgs, nix-gaming, ... }: {
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      foliate # e-book reader
      eza # modern 'ls' replacement
      ripgrep # modern 'grep' replacement
      tiny # IRC client
      rounded-mgenplus # japanese font
      ouch # painless compression/decompression
      libnotify # notification library
      pamixer # pipewire manipulation
      gnupg # GnuPG
      bottom # system 'top'
      gammastep # eye control
      hyprpicker # color picker
      wl-clipboard # wayland clipboard
      grim # grap images for wayland (screenshots)
      slurp # geometry selection for wayland (screenshots)
      waylock # wayland screen locker
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      cachix # caches for stuff
      mpv # media viewer

      # Games
      nix-gaming.packages.${pkgs.system}.osu-stable
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
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
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
