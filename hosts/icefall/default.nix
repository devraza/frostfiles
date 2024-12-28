{
  config,
  pkgs,
  pkgs-unstable,
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
    kernelPackages = pkgs.linuxPackages_cachyos-server; # Use the cachyOS server kernel
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 1; # A quieter boot
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    loader.grub = {
      efiSupport = true;
      device = "nodev";
    };
    supportedFilesystems = [ "ntfs" ];
    # Sysctl values
    kernel.sysctl = {
      # Lower swappiness to 5
      "vm.swappiness" = 5;
    };
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
    dates = "daily";
  };
  # Disable suspend on laptop lid close
  services.logind.lidSwitch = "ignore";

  nix = {
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "daily";
      options = "-d";
    };
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true; # Optimise the nix store
      allowed-users = [ "@wheel" ]; # only allow those in the `wheel` group to use the package manager
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    package = pkgs.nix;
  };

  # Restrict execution
  fileSystems = {
    "/home".options = [ "noexec" ];
  };

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
  };

  # Miscellaneous performance
  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 80; # stop charging at 80%
    };
  };
  services.thermald.enable = true;

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

  time.timeZone = "Europe/London"; # Set time zone.

  # grafana monitoring configuration
  services.grafana = {
    enable = true;
    declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    dataDir = "/home/devraza";
    openDefaultPorts = true;
    configDir = "/home/devraza/.config/syncthing";
    user = "devraza";
    group = "users";
    guiAddress = "0.0.0.0:8384";
  };

  # Scrutiny
  services.smartd = {
    enable = config.services.scrutiny.collector.enable;
  };
  services.scrutiny = {
    enable = true;
    collector.enable = true;
    settings.web = {
      influxdb.host = "127.0.0.1";
      listen = {
        host = "127.0.0.1";
        port = 9070;
      };
    };
  };

  # Sonarr
  services.sonarr = {
    enable = true;
    package = pkgs-unstable.sonarr;
  };

  # Enable irqbalance
  services.irqbalance.enable = true;

  # Prometheus configuration
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "alpha";
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
      {
        job_name = "beta";
        static_configs = [ { targets = [ "100.64.0.6:4001" ]; } ];
      }
    ];
  };

  # Media server
  services.jellyfin.enable = true;

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

  services.tailscale.enable = true;

  virtualisation = {
    # Containerization - docker alternative, podman
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        flags = [
          "--all"
        ];
      };
    };
  };

  # Networking
  networking = {
    hostName = "icefall"; # hostname

    # Enable the firewall
    firewall = {
      enable = true;

      rejectPackets = true;
      pingLimit = "--limit 10/minute --limit-burst 5";
      allowPing = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];

      # Allowed ports on interface enp0s31f6
      interfaces = {
        enp0s31f6.allowedTCPPorts = [
          80
          443
          2049
          7777
          8029
          25570
        ];
        enp0s31f6.allowedUDPPorts = [
          80
          443
          2049
          7777
          8029
          25570
        ];
        "podman+".allowedUDPPorts = [ 53 ];
      };

      # All ports are allowed on these interfaces
      trustedInterfaces = [
        "tailscale0"
        "virbr0"
      ];
    };

    interfaces.enp0s31f6.ipv4.addresses = [
      {
        address = "192.168.1.78";
        prefixLength = 24;
      }
    ];

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
    ]; # Add some groups
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr3Ue81NlnIOMxtHEZNPbvZCxRpOfiEsFj02CPDlMkq frigidslash"
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # DBus service for automounting disks
  services.udisks2.enable = true;

  # cronjobs
  services.cron.systemCronJobs = [
    "0 4 * * 0 root reboot"
    "0 * * * * devraza . /etc/profile; cd /etc/nixos; ${pkgs.git}/bin/git pull"
    "0 19 * * * root ${pkgs.restic}/bin/restic --repo /var/lib/backup backup /mnt/codebreaker/Documents /var/lib /mnt/codebreaker/Media/Blender /mnt/codebreaker/Media/Books /mnt/codebreaker/Media/Pictures /home/devraza/Sync --exclude-file /var/lib/backup/exclude.txt -p /etc/backup.key"
    "0 1 * * 0 root ${pkgs.util-linux}/bin/mountpoint /mnt/cosmolight || ${pkgs.mount}/bin/mount /dev/disk/by-label/cosmolight /mnt/cosmolight && ${pkgs.restic}/bin/restic --repo /mnt/cosmolight backup /mnt/codebreaker/ -p /etc/cosmolight.key"
  ];

  # Optimise for reducing power usage
  powerManagement.cpuFreqGovernor = "powersave";

  # Define system packages
  environment.systemPackages = with pkgs; [
    restic
    neovim
    podman-compose
    cryptsetup
    kiwix-tools
  ];

  # Media group
  users.groups.media.members = [
    "sonarr"
    "jellyfin"
    "calibre-web"
  ];

  # Define the system stateVersion, shouldn't be changed
  system.stateVersion = "23.11";
}
