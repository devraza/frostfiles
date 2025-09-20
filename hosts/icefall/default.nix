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
    tmp.cleanOnBoot = true;
  };

  # Create swapfile
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

  # ddclient for updating dynamic DNS
  services.ddclient = {
    enable = true;
    domains = [
      "atiran.giize.com"
      "devraza.giize.com"
    ];
    username = "devraza";
    passwordFile = "/etc/dynu.key";
    server = "api.dynu.com";
    usev4 = "webv4, webv4=checkip.dynu.com/, webv4-skip='IP Address'";
  };

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
  # Disable suspend on laptop lid close
  services.logind.lidSwitch = "ignore";

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

  # Forgejo configuration
  services.forgejo = {
    stateDir = "/var/lib/git";
    enable = true;
    package = pkgs.forgejo;
    settings = {
      DEFAULT.APP_NAME = "Devraza's Smithy";
      service.DISABLE_REGISTRATION = true;
      repository = {
        DISABLE_STARS = true;
      };
      server = {
        DISABLE_SSH = false;
        SSH_PORT = 2222;
        DOMAIN = "devraza.giize.com";
        HTTP_PORT = 4000;
        HTTP_ADDR = "127.0.0.1";
        ROOT_URL = "https://git.devraza.giize.com/";
        START_SSH_SERVER = true;
      };
    };
  };

  # Vikunja - self-hosted todo
  services.vikunja = {
    enable = true;
    frontendHostname = "todo";
    frontendScheme = "http";
    settings = {
      service = {
        interface = lib.mkForce "0.0.0.0:3456";
        enableregistration = true;
        allowiconchanges = false;
      };
    };
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
    certs."devraza.giize.com" = {
      domain = "devraza.giize.com";
      dnsProvider = "dynu";
      environmentFile = "/etc/acme.env";
      group = config.services.caddy.group;
    };
    certs."atiran.giize.com" = {
      domain = "atiran.giize.com";
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

  services.netbird.enable = true;

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
      allowedUDPPorts = [ 80 443 2222 ];
      allowedTCPPorts = [ 80 443 2222 ];

      # Allowed ports on interfaces
      interfaces = {
        "podman+".allowedUDPPorts = [ 53 ];
      };

      # All ports are allowed on these interfaces
      trustedInterfaces = [
        "wt0"
        "virbr0"
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
    "0 * * * * devraza . /etc/profile; cd /etc/nixos; ${pkgs.git}/bin/git pull"
    "0 19 * * * root ${pkgs.restic}/bin/restic --repo /var/lib/backup backup /mnt/codebreaker/Documents /var/lib /mnt/codebreaker/Media/Blender /mnt/codebreaker/Media/Books /mnt/codebreaker/Media/Pictures /home/devraza/Sync --exclude-file /var/lib/backup/exclude.txt -p /etc/backup.key"
  ];

  # Optimise for reducing power usage
  powerManagement.cpuFreqGovernor = "performance";

  # Define system packages
  environment.systemPackages = with pkgs; [
    restic
    neovim
    podman-compose
    cryptsetup
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
