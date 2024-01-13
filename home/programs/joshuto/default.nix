{ pkgs, ... }:
{
  # Joshuto - CLI file manager in Rust
  programs.joshuto = {
    enable = true;
    settings = {
      mode = "default";
      automatically_count_files = true;

      use_trash = false;

      collapse_preview = true;
      column_ratio = "[1, 4, 4]";
      tilde_in_titlebar = true;

      show_borders = true;
      show_hidden = true;
      show_icons = true;
    };
  };
  xdg.configFile."joshuto/mimetype.toml".source = ./mimetype.toml;
}
