{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # Imports
  imports = [
    ./hardware.nix
    ./services
  ];

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 1; # A quieter boot
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    loader.systemd-boot.enable = true;
    tmp.cleanOnBoot = true;
  };

  # Create swapfile
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

  # Automatic upgrades
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # prints the build logs
    ];
    dates = "weekly";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "-d";
    };
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    package = pkgs.nix;
  };

  # Automatically get new certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "devraza.hazard643@slmail.me";
    certs."permafrost.gleeze.com" = {
      dnsProvider = "dynu";
      domain = "permafrost.gleeze.com";
      environmentFile = "/etc/acme.env";
      group = config.services.caddy.group;
    };
    certs."subdomains-permafrost" = {
      dnsProvider = "dynu";
      domain = "*.permafrost.gleeze.com";
      environmentFile = "/etc/acme.env";
      group = config.services.caddy.group;
    };
    certs."devraza.giize.com" = {
      domain = "devraza.giize.com";
      dnsProvider = "dynu";
      environmentFile = "/etc/acme.env";
      group = config.services.caddy.group;
    };
    certs."subdomains" = {
      domain = "*.devraza.giize.com";
      dnsProvider = "dynu";
      environmentFile = "/etc/acme.env";
      group = config.services.caddy.group;
    };
  };

  # Vikunja - self-hosted todo
  services.vikunja = {
    enable = true;
    frontendHostname = "todo";
    frontendScheme = "http";
    settings = {
      service = {
        interface = lib.mkForce "127.0.0.1:3456";
        enableregistration = true;
        allowiconchanges = false;
      };
    };
  };

  # Restrict execution
  fileSystems = {
    "/home".options = [ "noexec" ];
  };

  security = {
    apparmor.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
    # Enable polkit
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

  time.timeZone = "Europe/Berlin"; # Set time zone.

  # Syncthing
  services.syncthing = {
    enable = true;
    dataDir = "/home/devraza";
    openDefaultPorts = true;
    configDir = "/home/devraza/.config/syncthing";
    user = "devraza";
    group = "users";
    guiAddress = "127.0.0.1:8384";
  };

  # Calibre web
  services.calibre-web = {
    enable = true;
    listen = {
      ip = "127.0.0.1";
      port = 7074;
    };
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };

  # Overlay mesh network
  services.tailscale.enable = true;
  boot.kernel.sysctl = {
   "net.ipv4.ip_forward" = 1;
   "net.ipv6.conf.all.ip_forward" = 1;
  };

  # Networking
  networking = {
    hostName = "cryogenesis"; # hostname

    # Enable the firewall
    firewall = {
      enable = true;

      rejectPackets = true;
      pingLimit = "--limit 10/minute --limit-burst 5";
      allowPing = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ 80 443 2222 ];
      allowedTCPPorts = [ 80 443 2222 ];

      # Allowed ports on interfaces
      interfaces = {
        "podman+".allowedUDPPorts = [ 53 ];
      };

      # All ports are allowed on these interfaces
      trustedInterfaces = [
        "tailscale0"
      ];
    };

    networkmanager.enable = true;
  };

  # Define user 'devraza'
  users.users.devraza = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr3Ue81NlnIOMxtHEZNPbvZCxRpOfiEsFj02CPDlMkq frigidslash"
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # cronjobs
  services.cron.systemCronJobs = [
    "0 * * * * devraza . /etc/profile; cd /etc/nixos; ${pkgs.git}/bin/git pull"
  ];

  # Define system packages
  environment.systemPackages = with pkgs; [
    neovim
    podman-compose
  ];

  # Media group
  users.groups.media.members = [
    "calibre-web"
  ];

  # Define the system stateVersion, shouldn't be changed
  system.stateVersion = "23.11";
}
