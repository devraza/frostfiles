{
  imports = [
    ./games

    ./eww # widgets
    ./rbw # password manager
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
    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
    /*
    rofi = {
      name = "Rofi";
      terminal = false;
      exec = "rofi -show drun";
      noDisplay = true;
    };
    rofi-theme-selector = {
      name = "Rofi Theme Selector";
      exec = "rofi-theme-selector";
      noDisplay = true;
    };
    */
    gammastep-indicator = {
      name = "Gammastep Indicator";
      exec = "gammastep-indicator";
      noDisplay = true;
    };
  };
}
