{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    theme = {
      status = {
        separator_open  = "";
        separator_close = "";
      };
      mode = {
        normal_alt = {
          bg = "darkgray";
        };
        select_alt = {
          bg = "darkgray";
        };
        unset_alt = {
          bg = "darkgray";
        };
      };
      manager = {
        border_symbol = "│";
        border_style = { fg = "darkgray"; };
      };
    };
  };

  home.packages = [
    pkgs.ueberzugpp
  ];

  xdg.configFile."yazi/yazi.toml".source = ./yazi.toml;
}
