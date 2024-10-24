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
  networking.hostName = "frigidslash";

  # Define the system stateVersion
  system.stateVersion = "23.11";
}
