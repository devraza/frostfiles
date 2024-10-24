{
  imports = [
    ./games

    ./eww # widgets
    ./fish # shell
    ./git
    ./alacritty # terminal emulator
    ./starship # cool terminal prompt
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
