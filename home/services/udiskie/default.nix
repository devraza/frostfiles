{ pkgs-stable, ... }:
{
  services.udiskie = {
    enable = true;
    package = pkgs-stable.udiskie;
  };
}
