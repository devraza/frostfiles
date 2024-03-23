{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      better-escape-nvim
      alpha-nvim
      glow-nvim
      lush-nvim
      plenary-nvim
      nvim-web-devicons
      neogit
      diffview-nvim
      telescope-nvim
      barbar-nvim
      lualine-nvim
      which-key-nvim
      nvim-lspconfig
      neorg
      neorg-telescope
      lazy-nvim
      nvim-tree-lua
      toggleterm-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "kagayaki.nvim";
        version = "2024-03-23";
        src = pkgs.fetchFromGitHub {
          owner = "devraza";
          repo = "kagayaki.nvim";
          rev = "e5398135920a5afadd7e5b8d5fa1d0d0e3ff1bac";
          sha256 = "sha256-IT82i/v1aUPqY2NupLPMTgqN3Kz5hXEpQUm97VjdJrc=";
        };
      })
    ];
  };

  home.packages = with pkgs; [
    gcc
    neovide
  ];
}
