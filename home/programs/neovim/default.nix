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
        version = "2024-02-08";
        src = pkgs.fetchFromGitHub {
          owner = "devraza";
          repo = "kagayaki.nvim";
          rev = "d91aae17586a7b52b5f8ec6d3f4a514632e4bf22";
          sha256 = "1bpl8s1bmffiqdh2pwnmcazgl30zkkbl06zvh584wdfs500kjp0g";
        };
      })
    ];
  };

  home.packages = with pkgs; [
    gcc
    neovide
  ];
}
