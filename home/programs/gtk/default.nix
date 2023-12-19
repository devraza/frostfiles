{ pkgs, ... }:
{
  # Set the configurations for both gtk3 and gtk4
  xdg.configFile."gtk-4.0/gtk.css".source = ./gtk-4.0/gtk.css;
  xdg.configFile."gtk-3.0/gtk.css".source = ./gtk-3.0/gtk.css;

  # Misc. GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Iosevka Comfy";
      package = pkgs.iosevka-comfy.comfy;
    };
  };
}
