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
        version = "2024-03-26";
        src = pkgs.fetchFromGitHub {
          owner = "devraza";
          repo = "kagayaki.nvim";
          rev = "49394403a6a279db539e805695b70a706c94ef72";
          sha256 = "sha256-NLbqedolfQtpoAWMFmixHtBhrD8SWbAsGZ8LXNnR/vU=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        pname = "typst-preview.nvim";
        version = "2024-03-23";
        src = pkgs.fetchFromGitHub {
          owner = "chomosuke";
          repo = "typst-preview.nvim";
          rev = "36a82aaff8931f96015ee7365afe2e253ab3b1ea";
          sha256 = "sha256-esKT3tRoO28a1dXVS4q6pnEM/GQnuLn5zi0LsRxmFS8=";
        };
      })
    ];
  };

  home.packages = with pkgs; [
    gcc
    neovide
  ];
}
