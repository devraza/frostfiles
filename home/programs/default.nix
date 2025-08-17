{
  imports = [
    ./games

    ./fish # shell
    ./git
    ./alacritty # terminal emulator
    ./starship # cool terminal prompt
    ./gtk # GTK configuration
    ./ssh # SSH configuration
    ./neovim # text editor
    ./hyprland # window manager
    ./rofi # launcher
    ./yazi # file manager
  ];

  xdg.desktopEntries = {
    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
    gammastep-indicator = {
      name = "Gammastep Indicator";
      exec = "gammastep-indicator";
      noDisplay = true;
    };
  };
}
