{ config, pkgs, ... }:

{
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
      starship # shell prompt in Rust
      tiny # IRC client
      rounded-mgenplus # japanese font
      dconf # dconf
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
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "neovide";
    };
  };

  # Enable flakes
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts
    ./modules # modules

    (let
      declCachix = builtins.fetchTarball "https://github.com/devraza/declarative-cachix/archive/master.tar.gz";
     in 
       import "${declCachix}/home-manager.nix")
  ];

  caches.cachix = [
    "nix-community"
    "nix-gaming"
  ];
}
