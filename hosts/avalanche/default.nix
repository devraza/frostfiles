# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # Define trusted users
  nix.settings.trusted-users = [
    "devraza"
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

  # Use unstable by default
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  # Enable GameMode
  programs.gamemode.enable = true;

  # Networking
  networking = {
    hostName = "avalanche";
    # Enable NetworkManager
    networkmanager = {
      enable = true;
    };
  };

  # Set time zone.
  time.timeZone = "Europe/London";

  # Security
  security = {
    sudo.wheelNeedsPassword = false; # disable the need for a password when using 'sudo'
    rtkit.enable = true; # make PipeWire real-time capable
  };

  # Sound via PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user 'devraza'
  users.users.devraza = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Add some groups
  };

  # Enable dconf - for gtk
  programs.dconf.enable = true;
  # pinentry-gnome3 fix
  services.dbus.packages = [ pkgs.gcr ];

  # OpenGL configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # uPower
  services.upower.enable = true;

  # Enable the firewall
  networking.firewall.enable = true;

  # This value determines the NixOS release of install
  system.stateVersion = "23.05";

  # Pipewire low latency pulse backend
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
  }
