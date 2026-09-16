{
  imports = [
    ./games

    ./fish # shell
    ./git # git
    ./alacritty # terminal emulator
    ./starship # cool terminal prompt
    ./gtk # GTK configuration
    ./emacs # text editor...and more
    ./qutebrowser # web browser
    ./mango # window manager
    ./noctalia # system shell
    ./yazi # file manager
  ];

  xdg.desktopEntries = {
    "nixos-manual" = {
      name = "NixOS Manual";
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
  };
}
