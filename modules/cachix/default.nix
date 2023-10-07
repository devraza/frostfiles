{pkgs, ...}: let
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  # install packages
  home.packages = [ # or home.packages
    nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable
  ];
}
