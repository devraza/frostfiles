{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  # Emacs daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
}
