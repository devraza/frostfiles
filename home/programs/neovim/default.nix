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
  };
  home.packages = with pkgs; [
    neovide
  ];
}
