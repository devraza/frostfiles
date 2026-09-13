{ pkgs, ... }:
{
  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Rose-Pine";
      };

      wallpaper = {
        enabled = true;
        default.path = "/etc/nixos/home/assets/wallpapers/tower-horizon.jpg";
      };
    };
  };

  home.packages = with pkgs; [
    libqalculate
  ];
}
