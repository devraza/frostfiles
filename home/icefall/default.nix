{ config, pkgs, ... }: 
{
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.11";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      fd # modern 'find' replacement
      du-dust # modern 'dust' replacement
      eza # modern 'ls' replacement
      ripgrep # modern 'grep' replacement
      ouch # painless compression/decompression
      bottom # system 'top'

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gopass # password manager
      gnupg # GnuPG
    ];
  };

  fonts.fontconfig.enable = true; # enable fontconfig

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./services # services
    ./programs # programs
  ];
}
