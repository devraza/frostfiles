{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
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
      typst-vim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "kagayaki.nvim";
        version = "2024-03-26";
        src = pkgs.fetchFromGitHub {
          owner = "devraza";
          repo = "kagayaki.nvim";
          rev = "49394403a6a279db539e805695b70a706c94ef72";
          sha256 = "sha256-NLbqedolfQtpoAWMFmixHtBhrD8SWbAsGZ8LXNnR/vU=";
        };
      })
    ];
  };

  home.packages = with pkgs; [
    gcc
    neovide
    luajitPackages.lua-utils-nvim
  ];
}
