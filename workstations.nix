{ inputs, config, pkgs, pkgs-stable, musnix, lib, ... }:
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
      allowed-users = [ "@wheel" ]; # only allow those in the `wheel` group to use the package manager
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    package = pkgs.nix;
  };

  # Shared kernel + related configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [ "quiet" "splash" "mitigations=off" "intel_pstate=disable" "nowatchdog" "i915.fastboot=1" "ipv6.disable=1" ];

    # Clean /tmp on boot, obviously
    tmp.cleanOnBoot = true;
  };

  # adb (Android)
  programs.adb.enable = true;

  # NAS
  fileSystems."/home/devraza/NAS" = {
    device = "icefall:/codebreaker";
    fsType = "nfs";
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # libusbmuxd
  services.usbmuxd.enable = true;

  # Power and thermal management
  services.tlp.enable = true;
  services.thermald.enable = true;

  # Fuse allow other users
  programs.fuse.userAllowOther = true;

  # Remove unused default packages
  environment.defaultPackages = lib.mkForce [ ];

  # Auto nice daemon
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp-rules;
  };

  # earlyoom
  services.earlyoom.enable = true;

  # Enable polkit
  security = {
    apparmor.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          var YES = polkit.Result.YES;
          var permission = {
            // udisks2:
            "org.freedesktop.udisks2.filesystem-mount": YES,
            "org.freedesktop.udisks2.encrypted-unlock": YES,
            "org.freedesktop.udisks2.eject-media": YES,
            "org.freedesktop.udisks2.power-off-drive": YES,
            // udisks2 if using udiskie from another seat (e.g. systemd):
            "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
            "org.freedesktop.udisks2.filesystem-unmount-others": YES,
            "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
            "org.freedesktop.udisks2.encrypted-unlock-system": YES,
            "org.freedesktop.udisks2.eject-media-other-seat": YES,
            "org.freedesktop.udisks2.power-off-drive-other-seat": YES
          };
          if (subject.isInGroup("storage")) {
            return permission[action.id];
          }
        });
      '';
    };
  };

  # Don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Printing
  services.printing.enable = true; # enables printing support via the CUPS daemon
  services.avahi = {
    enable = true; # runs the Avahi daemon
    nssmdns4 = true; # enables the mDNS NSS plug-in
  };

  services.tor.enable = true; # Enable tor

  programs.gamemode = {
    enable = true; # Enable GameMode
    settings = {
      general = {
        renice = 20;
        igpu_power_threshold = -1;
        igpu_desiredgov = "performance";
      };
    };
  };

  time.timeZone = "Europe/London"; # Set time zone.

  # Security
  security = {
    rtkit.enable = true; # make PipeWire real-time capable
    pam = {
      services.swaylock = { };
    };

    # sudo
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    # disable IPv6
    enableIPv6 = false;

    # Use the newer nftables
    nftables.enable = true;

    firewall = {
      enable = true;
      rejectPackets = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  services.tailscale.enable = true;

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
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "adbusers" "libvirtd" ]; # Add some groups
  };

  # Enable dconf - for gtk
  programs.dconf.enable = true;
  # pinentry-gnome3 fix
  services.dbus.packages = [ pkgs.gcr ];

  # Graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # uPower
  services.upower.enable = true;

  # Real-time audio for NixOS
  musnix.enable = true;

  # Enables support for SANE scanners
  hardware.sane.enable = true;

  # Enable the Hyprland NixOS module, enabling critical components
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };

  # file system trimming
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # DBus service for automounting disks
  services.udisks2.enable = true;
}
