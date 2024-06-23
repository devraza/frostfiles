# home.nix

{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    neovide
    alacritty

    # macOS
    yabai
    skhd

    # command-line utilities
    du-dust
    ripgrep
    just
    sd
    bat
    eza
    dogdns
    rustscan
    ouch
    procs
    tokei
    fd
    bottom
    git
  ];

  home.sessionVariables = {
    EDITOR = "neovide";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
