{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # Imports
  imports = [ ./hardware.nix ];

  # Gamemode
  programs.gamemode.enable = true;

  # Networking
  networking.hostName = "frigidflash";

  # Define the system stateVersion
  system.stateVersion = "24.05";
}
