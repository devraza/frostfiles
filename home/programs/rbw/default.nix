{ pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "razadev@proton.me";
      base_url = "https://vault.devraza.giize.com";
      lock_timeout = 1200;
      pinentry = pkgs.pinentry-gnome3;
    };
  };
  home.packages = [ pkgs.rofi-rbw-wayland ];
}
