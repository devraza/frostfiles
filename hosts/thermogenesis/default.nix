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
      "ipv6.disable=1"
    ];
    consoleLogLevel = 1; # A quieter boot
    loader.grub = {
      efiSupport = false;
      device = "/dev/sda";
    };
    supportedFilesystems = [ "ntfs" ];
    # Sysctl values
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.core.optmem_max" = 65536;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.udp_rmem_min" = 8192;
      "net.ipv4.udp_wmem_min" = 8192;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      "net.ipv4.tcp_max_tw_buckets" = 2097152;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_slow_start_after_idle" = 0;

      # Lower swappiness to 10
      "vm.swappiness" = 10;
    };
    tmp.cleanOnBoot = true;
  };

  # Disable NVIDIA
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
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
    "/boot".options = [ "noexec" ];
    "/home".options = [ "noexec" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "devraza.hazard643@slmail.me";
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

  # Create swapfile
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];

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

  # Forgejo configuration
  services.forgejo = {
    stateDir = "/var/lib/git";
    enable = true;
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

  # ddclient for updating dynamic DNS
  services.ddclient = {
    enable = true;
    domains = [
      "barneyland.gleeze.com"
      "devraza.giize.com"
    ];
    username = "devraza";
    passwordFile = "/etc/dynu.key";
    server = "api.dynu.com";
    usev4 = "webv4, webv4=checkip.dynu.com/, webv4-skip='IP Address'";
  };

  # Blocky
  services.blocky = {
    enable = true;
    settings = {
      prometheus.enable = true;
      blocking = {
        blackLists.ads = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          "https://sysctl.org/cameleon/hosts"
          "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
          "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
        ];
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };
      upstreams = {
        groups.default = [
          "9.9.9.9"
          "1.1.1.1"
        ];
      };
      customDNS = {
        mapping = {
          "icefall" = "100.64.0.7";
          "thermogenesis" = "100.64.0.6";
        };
      };
      ports = {
        dns = "0.0.0.0:53";
        http = "0.0.0.0:4001";
      };
    };
  };

  time.timeZone = "Europe/London"; # Set time zone.

  # Enable irqbalance
  services.irqbalance.enable = true;

  services.tailscale.enable = true;

  # Headscale configuration
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 7070;
    settings = {
      policy.path = "/var/lib/headscale/policy.json";
      logtail.enabled = false;
      server_url = "https://hs.devraza.giize.com";
      dns = {
        base_domain = "permafrost.net";
        nameservers.global = [
          "9.9.9.9"
          "1.1.1.1"
        ];
        override_local_dns = true;
      };
      derp.update_frequency = "24h";
    };
  };

  virtualisation = {
    # Containerization - docker alternative, podman
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Networking
  networking = {
    hostName = "thermogenesis"; # hostname

    # Set fallback DNS servers
    nameservers = [
      "9.9.9.9"
      "1.1.1.1"
    ];

    # Enable the firewall
    firewall = {
      enable = true;

      rejectPackets = true;
      pingLimit = "--limit 10/minute --limit-burst 5";
      allowPing = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];

      # Allowed ports on interface enp9s0
      interfaces = {
        enp9s0.allowedTCPPorts = [
          80
          443
          2222
          4001
          8448
        ];
        enp9s0.allowedUDPPorts = [
          80
          443
          2222
          4001
          8448
        ];
        podman0.allowedUDPPorts = [ 53 ];
      };

      # Allowed ports on tailscale
      trustedInterfaces = [ "tailscale0" ];
    };

    interfaces.enp9s0.ipv4.addresses = [
      {
        address = "192.168.1.247";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.1.254";
    networkmanager.enable = true;
    # disable IPv6
    enableIPv6 = false;
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPznTtRCmbv/04OGZApQPn3lzosrjLuckw00gdYbMZF elysia"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr3Ue81NlnIOMxtHEZNPbvZCxRpOfiEsFj02CPDlMkq frigidslash"
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # DBus service for automounting disks
  services.udisks2.enable = true;

  # Reboot every 24 hours
  services.cron.systemCronJobs = [
    "0 4 * * 0 root reboot"
    "0 * * * * devraza . /etc/profile; cd /etc/nixos; ${pkgs.git}/bin/git pull"
    "0 19 * * * root ${pkgs.restic}/bin/restic backup /var/lib --exclude-file /var/lib/backup/exclude.txt -p /etc/backup.key"
  ];

  # Performance!
  powerManagement.cpuFreqGovernor = "powersave";

  # Define system packages
  environment.systemPackages = with pkgs; [
    config.services.headscale.package
    restic
    neovim
    podman-compose
  ];

  # Define the system stateVersion
  system.stateVersion = "23.11";
}
