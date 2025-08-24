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
    "nixos-manual" = {
      name = "NixOS Manual";
      noDisplay = true;
    };
    "netbird" = {
      name = "NetBird @ netbird";
      noDisplay = true;
    };
    "cups" = {
      name = "Manage Printing";
      noDisplay = true;
    };
    "fish" = {
      name = "fish";
      exec = "fish";
      noDisplay = true;
    };
    "gammastep-indicator" = {
      name = "Gammastep Indicator";
      exec = "gammastep-indicator";
      noDisplay = true;
    };
    "bottom" = {
      name = "bottom";
      noDisplay = true;
    };
    "yazi" = {
      name = "Yazi";
      noDisplay = true;
    };
    "rofi" = {
      name = "Rofi";
      noDisplay = true;
    };
    "rofi-theme-selector" = {
      name = "Rofi Theme Selector";
      noDisplay = true;
    };
  };
}
