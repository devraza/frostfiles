{ config, pkgs, inputs, lib, ... }:
{
  # Imports
  imports = [
    ./hardware-configuration.nix
    ./services
  ];

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest; # Use the realtime kernel by default
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

      # Lower swappiness
      "vm.swappiness" = 10;
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
  };

  nixpkgs.config.allowUnfree = true;

  # zram
  zramSwap.enable = true;
  
  # Various on-boot things
  systemd.services."startup" = {
    script = with pkgs; ''
      # Restart headscale after some time
      sleep 600
      systemctl restart headscale

      # Mount the disk
      ${cryptsetup}/bin/cryptsetup -d /etc/codebreaker.key luksOpen /dev/sdb1 codebreaker
      ${mount}/bin/mount /dev/mapper/codebreaker /mnt/codebreaker
    '';
    serviceConfig = {
      type = "oneshot";
      user = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "networkmanager.service"
    ];
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

  time.timeZone = "Europe/London"; # Set time zone.

  # grafana monitoring configuration
  services.grafana = {
    enable = true;
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-piechart-panel
    ];
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        domain = "localhost";
      };
    };
  };

  # Sonarr
  services.sonarr.enable = true;

  # Vikunja - self-hosted todo
  services.vikunja = {
    enable = true;
    frontendHostname = "todo";
    frontendScheme = "https";
    settings = {
      service = {
        enableregistration = false;
      };
    };
  };

  # Gitea configuration
  services.gitea = {
    enable = true;
    settings = {
      DEFAULT.APP_NAME = "Devraza's git repositories";
      ui = {
        THEMES = "dark-arc, gitea, arc-green";
        DEFAULT_THEME = "dark-arc";
      };
      service.DISABLE_REGISTRATION = true;
      repository = {
        DISABLE_STARS = true;
      };
      server = {
        DISABLE_SSH = false;
        SSH_PORT = 2222;
        DOMAIN = "devraza.duckdns.org";
        HTTP_PORT = 4000;
        HTTP_ADDR = "127.0.0.1";
        ROOT_URL = "https://git.devraza.duckdns.org/";
        START_SSH_SERVER = true;
      };
    };
    user = "gitea";
  };

  # Uptime kuma configuration
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = "5079";
    };
  };

  fileSystems = {
    "/".options = [ "noexec" ];
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
    ];
  };

  # Media server
  services.jellyfin.enable = true;

  # Enable dashboard
  services.homepage-dashboard.enable = true;

  # Calibre web
  services.calibre-web = {
    enable = true;
    listen = {
      ip = "0.0.0.0";
      port = 7074;
    };
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };

  systemd.services."calibre-web" = {
    after = [
      "startup.service"
    ];
  };

  # Headscale configuration
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 7070;
    settings = {
      logtail.enabled = false;
      server_url = "http://hs.devraza.duckdns.org";
      dns_config = {
        base_domain = "devraza.duckdns.org"; 
        nameservers = [ 
          "9.9.9.9"
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

  # SystemD configuration
  # The DuckDNS refresh
  systemd.timers."duckdns" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "duckdns.service";
    };
  };
  # SystemD services
  systemd.services = {
    "duckdns" = {
      script = ''
        ${pkgs.coreutils}/bin/echo url="https://www.duckdns.org/update?domains=devraza&token=579d5206-6fd4-469a-9a04-e122ebdaadce&ip=" | ${pkgs.curl}/bin/curl -k -K -
        ${pkgs.coreutils}/bin/echo url="https://www.duckdns.org/update?domains=gcsenotes&token=579d5206-6fd4-469a-9a04-e122ebdaadce&ip=" | ${pkgs.curl}/bin/curl -k -K -
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
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
      pingLimit = "--limit 60/minute --limit-burst 5";
      allowPing = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];

      # Allowed ports on interface enp9s0
      interfaces.enp9s0 = {
        allowedTCPPorts = [ 80 443 2222 8448 ];
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
