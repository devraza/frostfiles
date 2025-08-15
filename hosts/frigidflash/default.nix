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

  # Networking
  networking.hostName = "frigidflash";

  # Define the system stateVersion
  system.stateVersion = "24.05";
}
