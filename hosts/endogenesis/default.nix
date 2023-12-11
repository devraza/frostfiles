# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # Networking
  networking.hostName = "endogenesis";

  # Enable virt-manager and virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Give access to virtualisation group
  users.users.devraza.extraGroups = [ "libvirtd" ];

  # Set time zone.
  time.timeZone = "Europe/London";

  system.stateVersion = "23.05";
}
