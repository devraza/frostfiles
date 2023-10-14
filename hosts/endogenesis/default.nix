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
    kernelParams = [ "quiet" "splash" "nouveau.modeset=0" "pci=realloc" "nvidia-drm.modeset=1" "pcie_port_pm=off" "pcie_aspm=off" ];
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

  # Start the Surface book dGPU on boot as a systemd service
  systemd.services.dgpu = {
    enable = true;
    description = "Enable the SB1 dGPU";
    script = ''
      #!/bin/sh

      echo 1 | tee /sys/bus/platform/devices/MSHW0041:00/dgpu_power
      echo 1 > /sys/bus/pci/rescan
      ${pkgs.pciutils}/bin/setpci -H1 -s 01:00.0 6a.b=81
      ${pkgs.pciutils}/bin/setpci -H1 -s 01:00.0 4.w=0407
      echo 1 > /sys/bus/pci/rescan
      ${pkgs.pciutils}/bin/setpci -s 01:00.0 4.w
      ${pkgs.pciutils}/bin/setpci -s 01:00.0 6a.b
    '';
    wantedBy = [ "multi-user.target" ];
  };

  system.stateVersion = "23.05";
}
