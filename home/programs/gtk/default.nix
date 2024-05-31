{ pkgs, ... }:
{
  # Misc. GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "ZedMono Nerd Font";
      package = (pkgs.nerdfonts.override { fonts = [ "ZedMono" ]; });
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".source = ./gtk.css;
}
