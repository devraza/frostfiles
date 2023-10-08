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

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire-pulse.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "32/48000";
            pulse.default.req = "32/48000";
            pulse.max.req = "32/48000";
            pulse.min.quantum = "32/48000";
            pulse.max.quantum = "32/48000";
          };
        }
      ];
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };
  };

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
}
