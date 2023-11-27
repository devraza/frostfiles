# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, musnix, ... }:

{
  # Define trusted users
  nix = {
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true; # Optimise the nix store
      trusted-users = [
        "devraza"
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # Use the linux-zen kernel by default
    kernelParams = [ "quiet" "splash" "intel_pstate=disable" ];
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


  # Don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # autoUpgrade for a flake-enabled system
  system.autoUpgrade.flake = ./flake.nix;

  # Printing
  services.printing.enable = true; # enables printing support via the CUPS daemon
  services.avahi = {
    enable = true; # runs the Avahi daemon
    nssmdns = true; # enables the mDNS NSS plug-in
  };

  services.tor.enable = true; # Enable tor

  programs.gamemode.enable = true; # Enable GameMode

  time.timeZone = "Europe/London"; # Set time zone.

  # Security
  security = {
    sudo.wheelNeedsPassword = false; # disable the need for a password when using 'sudo'
    rtkit.enable = true; # make PipeWire real-time capable
    pam.services.waylock = { };
  };

  # Networking
  networking.networkmanager.enable = true;

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
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" ]; # Add some groups
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
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      pkgs.mesa.drivers
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # uPower
  services.upower.enable = true;

  # Enable the firewall
  networking.firewall.enable = true;

  # Real-time audio for NixOS
  musnix.enable = true;

  # Enables support for SANE scanners
  hardware.sane.enable = true;

  # Enable the Hyprland NixOS module, enabling critical components
  programs.hyprland.enable = true;

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
