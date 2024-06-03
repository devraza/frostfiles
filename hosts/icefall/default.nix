{ config, pkgs, inputs, lib, ... }:
{
  # Imports
  imports = [
    ./hardware-configuration.nix
    ./services
  ];

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-server; # Use the cachyOS server kernel
    kernelParams = [ "quiet" "splash" ];
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

      # Lower swappiness to 0
      "vm.swappiness" = 0;
    };
    tmp.cleanOnBoot = true;
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
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true; # Optimise the nix store
      allowed-users = [ "@wheel" ]; # only allow those in the `wheel` group to use the package manager
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nix;
  };

  nixpkgs.config.allowUnfree = true;

  # zram
  zramSwap.enable = true;
  
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
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel
    ];
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
  };

  # Sonarr
  services.sonarr.enable = true;

  # Vikunja - self-hosted todo
  services.vikunja = {
    enable = true;
    frontendHostname = "todo";
    frontendScheme = "http";
    settings = {
      service = {
        interface = lib.mkForce "127.0.0.1:3456";
        enableregistration = false;
      };
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
          "icefall" = "100.64.0.2";
        };
      };
      ports = {
        dns = "0.0.0.0:53";
        http = "127.0.0.1:4001";
      };
    };
  };

  # SearXNG
  services.searx = {
    enable = true;
    settings = {
      server.port = 8888;
      server.bind_address = "127.0.0.1";
      server.secret_key = "@SEARX_SECRET_KEY@";
    };
  };

  # Enable irqbalance
  services.irqbalance.enable = true;

  fileSystems = {
    "/boot".options = [ "noexec" ];
  };

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
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "beta";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.blocky.settings.ports.http}" ];
        }];
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

  # Headscale configuration
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 7070;
    settings = {
      acl_policy_path = "/var/lib/headscale/policy.json";
      logtail.enabled = false;
      server_url = "http://hs.devraza.giize.com";
      dns_config = {
        base_domain = "devraza.giize.com"; 
        nameservers = [ 
          "100.64.0.2"
        ];
        override_local_dns = true;
      };
      derp.update_frequency = "24h";
    };
  };

  services.tailscale.enable = true;

  virtualisation = {
    libvirtd.enable = true; # libvirtd
    # Containerization - docker alternative, podman
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
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

      # Allowed ports on interface enp9s0
      interfaces = {
        enp9s0.allowedTCPPorts = [ 80 443 2222 8448 ];
        podman0.allowedUDPPorts = [ 53 ];
        podman1.allowedUDPPorts = [ 53 ];
        podman2.allowedUDPPorts = [ 53 ];
      };

      # Allowed ports on tailscale
      trustedInterfaces = [ "tailscale0" ];
    };

    interfaces.enp9s0.ipv4.addresses = [ {
      address = "192.168.1.246";
      prefixLength = 24;
    } ]; 

    defaultGateway = "192.168.1.254";
    networkmanager.enable = true;
    # disable IPv6
    enableIPv6 = false;
  };

  # Define user 'devraza'
  users.users.devraza = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "libvirtd" ]; # Add some groups
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/mImuPS8KNlD20q5QxSOim4uCGL27QAz4C8yGpcpwk razadev@proton.me"
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
  ];

  # Performance!
  powerManagement.cpuFreqGovernor = "powersave";

  # Define system packages
  environment.systemPackages = with pkgs; [
    config.services.headscale.package
    restic
    neovim
    dufs
    podman-compose
    cryptsetup
    kiwix-tools
  ];

  # Media group
  users.groups.media.members = [ "deluge" "sonarr" "jellyfin" "calibre-web" ];

  # Define the system stateVersion
  system.stateVersion = "23.11";
}
