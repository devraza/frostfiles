{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents ./init.lua;

    # Aliases for vi/vim1
    viAlias = false;
    vimAlias = true;

    plugins = [
      pkgs.vimPlugins.lush-nvim
    ];
  };

  # Add the other configuration files into the neovim configuration folder
  xdg.configFile."nvim/lua".source = ./lua;
}
