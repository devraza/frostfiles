{
  imports = [
    ./games

    ./eww # widgets
    ./hyprland # widgets
    ./fish # shell
    ./joshuto # file manager
    ./git
    ./alacritty # terminal emulator
    ./rofi # program launcher
    ./qutebrowser # browser
    ./starship # cool terminal prompt
    ./fcitx5 # IME
    ./gtk # GTK configuration
    ./ssh # SSH configuration
    ./neovim # text editor
  ];

  xdg.desktopEntries = {
    "osu!" = {
      name = "osu!";
      exec = "osu!";
      noDisplay = true;
    };
    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
    "steam" = {
      name = "Steam";
      exec = "steam";
      noDisplay = true;
    };
  };
}
