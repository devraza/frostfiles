{ config, pkgs, ... }:
let
  rose-pine-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "rose-pine-gtk-theme";
    version = "2.2.0-git";

    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "gtk";
      rev = "3a11f84e11685aacaa749deea1e9f02872b99fdf";
      hash = "sha256-58HfkFvflQhiJzfHcJCihSE9YbxbD6Koe0/aT+PVv4w=";
    };

    installPhase = ''
      mkdir -p $out/share/themes
      cp -r gtk3/* $out/share/themes/
    '';
  };
in
{
  # Misc. GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine-gtk";
      package = rose-pine-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    font = {
      name = "ZedMono Nerd Font";
      package = pkgs.nerd-fonts.zed-mono;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  gtk.gtk4.theme = config.gtk.theme;

  xdg.configFile."gtk-4.0/gtk.css".source = ./gtk.css;
}
