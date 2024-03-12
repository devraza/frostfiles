{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };

  home.packages = with pkgs; [
    gcc
    neovide
  ];
}
