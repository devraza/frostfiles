{ pkgs, ... }:
{
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
