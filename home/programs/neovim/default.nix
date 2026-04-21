{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      lazy-nvim
    ];
    withRuby = false;
    withPython3 = false;
    initLua = ''
      dofile(vim.fn.stdpath("config") .. "/base.lua")
    '';
  };
  home.packages = with pkgs; [
    neovide
  ];
}
