{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # macOS
    yabai
    skhd

    # Programs
    cinny-desktop

    # command-line utilities
    gnupg
    starship
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

    inputs.vaporise.packages.${pkgs.system}.default # `rm` alternative

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "ZedMono" ]; })
  ];

  home.sessionVariables = {
    EDITOR = "neovide";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [ ./programs ];
}
