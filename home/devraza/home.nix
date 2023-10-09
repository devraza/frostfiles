{ config, pkgs, inputs, ... }: {
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      steam # Steam
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
      waylock # wayland screen locker
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      cachix # caches for stuff
      mpv # media viewer
      xdg-utils # utilties for the XDG desktop standard
      neovide # neovim GUI
      font-awesome # font AWESOME

      # From the flake
      # ...

      # Games
      inputs.nix-gaming.packages.${pkgs.system}.osu-stable
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
