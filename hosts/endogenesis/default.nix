# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Imports
  imports = [ ./hardware.nix ];

  # Networking
  networking.hostName = "endogenesis";

  # Enable virt-manager
  programs.virt-manager.enable = true;

  networking.interfaces.wlp3s0.ipv4.addresses = [
    {
      address = "192.168.1.222";
      prefixLength = 24;
    }
  ];

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

  # Create swapfile
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "23.05";
}
