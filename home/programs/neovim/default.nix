{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents ./init.lua;

    # Aliases for vi/vim1
    viAlias = false;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      lush-nvim
      nvim-treesitter.withAllGrammars
      barbar-nvim
      glow-nvim
      dashboard-nvim
      nvim-web-devicons
      lualine-nvim
      telescope-nvim
      which-key-nvim
      nvim-tree-lua
    ];
  };

  # Add the other configuration files into the neovim configuration folder
  xdg.configFile."nvim/lua".source = ./lua;
}
