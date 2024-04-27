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

  # Enable virt-manager
  programs.virt-manager.enable = true;

  # Steam
  programs.steam.enable = true;

  # Bootloader configuration (grub)
  boot = {
    consoleLogLevel = 1; # A quieter boot
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "23.05";
}
