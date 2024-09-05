{
  inputs,
  config,
  pkgs,
  pkgs-stable,
  musnix,
  lib,
  ...
}:
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    package = pkgs.nix;
  };

  # Shared kernel + related configuration
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "mitigations=off"
      "nowatchdog"
    ];

    # Clean /tmp on boot, obviously
    tmp.cleanOnBoot = true;
  };

  # NAS
  fileSystems."/home/devraza/NAS" = {
    device = "icefall:/codebreaker";
    fsType = "nfs";
    options = [
      "soft"
      "noatime"
      "nodiratime"
      "x-systemd.automount"
      "noauto"
    ];
  };

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

  time.timeZone = "Europe/London"; # Set time zone.

  # Security
  security = {
    rtkit.enable = true; # make PipeWire real-time capable
    pam = {
      services.gtklock = { };
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

  # Support for tablet
  hardware.opentabletdriver.enable = true;

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
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
    ]; # Add some groups
  };

  # Enable dconf - for gtk
  programs.dconf.enable = true;
  # pinentry-gnome3 fix
  services.dbus.packages = [ pkgs.gcr ];

  # Graphics configuration
  hardware.graphics.enable = true;

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # uPower
  services.upower.enable = true;

  # Real-time audio for NixOS
  musnix.enable = true;

  # DBus service for automounting disks
  services.udisks2.enable = true;
}
