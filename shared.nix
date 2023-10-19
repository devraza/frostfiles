# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Use the linux-xanmod kernel by default
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # Define trusted users
  nix = {
    gc.automatic = true; # Automatic garbage collection
    settings = {
      auto-optimise-store = true; # Optimise the nix store
      trusted-users = [
        "devraza"
      ];
      experimental-features = [ "nix-command" "flakes" ];
      # Setup the nix-gaming cachix
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # autoUpgrade for a flake-enabled system
  system.autoUpgrade.flake = ./flake.nix;

  # Printing
  services.printing.enable = true; # enables printing support via the CUPS daemon
  services.avahi = {
    enable = true; # runs the Avahi daemon
    nssmdns = true; # enables the mDNS NSS plug-in
    openFirewall = true; # opens the firewall for UDP port 5353
  };

  services.tor.enable = true;

  # Enable GameMode
  programs.gamemode.enable = true;

  # Set time zone.
  time.timeZone = "Europe/London";

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

  # Real-time audio for NixOS
  musnix.enable = true;

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
