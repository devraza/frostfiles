{ config, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  # Used for backwards compatibility
  system.stateVersion = "24.05";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-linux";

  # Boot configuration
  boot = {
    consoleLogLevel = 1;
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
  networking.hostName = "elysium";

  # Tailscale
  services.tailscale.enable = true;
}
