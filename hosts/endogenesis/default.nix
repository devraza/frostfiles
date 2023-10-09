# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

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
  };

  # Networking
  networking.hostName = "endogenesis";

  # Set time zone.
  time.timeZone = "Europe/London";

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    powerManagement.enable = false; # disable power management
    powerManagement.finegrained = false; # disable fine-grained power management

    open = false; # disable the open-source kernel modules (GPU unsupported)

    # Enable the Nvidia settings menu,
    nvidiaSettings = true;

    # Select the appropriate driver version for the GPU.
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
  };

  system.stateVersion = "23.05";
}
