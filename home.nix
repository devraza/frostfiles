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
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "neovide";
    };
  };

  # Enable flakes
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
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
    # Programs
    ./programs
    # Services
    ./services
    # Scripts
    ./scripts
  ];

  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
    sshKeys = [
      "4C00B84E9C63D4ED01382BF739C1AFC7F2454060"
    ];
  };
}
