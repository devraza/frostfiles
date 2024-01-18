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

  # Create a swapfile
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }];

  # Enable virt-manager
  programs.virt-manager.enable = true;

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # Use the linux-zen kernel by default
    kernelParams = [ "quiet" "splash" "intel_pstate=disable" "nowatchdog" ];
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

  system.stateVersion = "23.05";
}
