{ config, pkgs, inputs, lib, ... }:

{
  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest; # Use the latest realtime kernel by default
    kernelParams = [ "quiet" "splash" ];
    consoleLogLevel = 1; # A quieter boot
    loader.grub = {
      efiSupport = false;
      device = "/dev/sda";
    };
  };

  nix = {
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "daily";
      options = "-d";
    };
    settings = {
      auto-optimise-store = true; # Optimise the nix store
      allowed-users = [ "@wheel" ]; # only allow those in the `wheel` group to use the package manager
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Create a swapfile
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }];

  # Various on-boot things
  systemd.services."startup" = {
    script = with pkgs; ''
      # Wait for the dependant services to settle
      sleep 10

      # Connect to the network
      ${networkmanager}/bin/nmcli d disconnect enp9s0
      ${networkmanager}/bin/nmcli d connect enp9s0

      # Start tailscale
      ${tailscale}/bin/tailscale up --login-server http://127.0.0.1:7070

      # Mount the disk
      ${mount}/bin/mount /dev/sdb1 /mnt/codebreaker
    '';
    serviceConfig = {
      type = "oneshot";
      user = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "networkmanager.service"
      "headscale.service"
    ];
  };

  # Enable polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
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

  time.timeZone = "Europe/London"; # Set time zone.

  services.openssh = {
    enable = true;
    # Some security settings
    ports = [
      6513 
    ];
    openFirewall = false;
    allowSFTP = false;
    settings = {
      AllowUsers = [ "devraza" ];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      PermitUserEnvironment no # Disable changing environment variables
      
      UseDNS yes # verify hostname and IP matches
      Protocol 2 # Use the newer SSH protocol only

      # Disable port forwarding
      AllowTcpForwarding no
      AllowStreamLocalForwarding no
      GatewayPorts no
      PermitTunnel no

      Compression no
      TCPKeepAlive no
      AllowAgentForwarding no

      # Disable rhosts
      IgnoreRhosts yes
      HostbasedAuthentication no

      # Other
      LoginGraceTime 20
      MaxSessions 2
      MaxStartups 2
    '';
  };

  # Fail2Ban configuration
  services.fail2ban = {
    enable = true;
    bantime = "6h";
  };

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
        domain = "localhost";
        root_url = "https://grafana.devraza.duckdns.org/";
      };
    };
  };

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;

  # Vikunja - self-hosted todo
  services.vikunja = {
    enable = true;
    frontendHostname = "todo";
    frontendScheme = "https";
    setupNginx = true;
    settings = {
      service = {
        enableregistration = false;
      };
    };
  };

  # SearX - search engine
  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "@SEARX_SECRET_KEY@";
        base_url = "https://search.devraza.duckdns.org/";
      };
    };
  };

  # Gitea configuration
  services.gitea = {
    enable = true;
    settings = {
      DEFAULT.APP_NAME = "Devraza's git repositories";
      ui = {
        DEFAULT_THEME = "arc-green";
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

  # Matrix configuration
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      allow_federation = false;
      database_backend = "rocksdb";
      allow_registration = true;
      address = "127.0.0.1";
      server_name = "matrix.devraza.duckdns.org";
    };
  };

  # Microbin configuration
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_BIND = "127.0.0.1";
      MICROBIN_PUBLIC_PATH = "https://bin.devraza.duckdns.org/";
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_DISABLE_TELEMETRY = true;
      MICROBIN_NO_LISTING = true;
    };
  };

  # Uptime kuma configuration
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      PORT = "5079";
    };
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

  # Enable dashboard
  services.homepage-dashboard.enable = true;

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
    address = "0.0.0.0";
    port = 7070;
    settings = {
      logtail.enabled = false;
      server_url = "https://headscale.devraza.duckdns.org";
      dns_config.base_domain = "devraza.duckdns.org"; 
    };
  };

  services.tailscale.enable = true;

  # Serve file server
  systemd.services."dufs" = {
    script = with pkgs; ''
      ${dufs}/bin/dufs -A -a devraza:Rl6KSSPbVHV0QHU1@/:rw -b 127.0.0.1 -p 8090 /mnt/codebreaker
    '';
    serviceConfig = {
      type = "simple";
      user = "root";
    };
    wantedBy = [ "multi-user.target" ];
    after = [
      "networkmanager.service"
    ];
  };

  # Nginx configuration
  services.nginx = {
    enable = true;
    clientMaxBodySize = "4096M"; # enable big files uploaded
    # Virtual hosts
    virtualHosts = {
      "nas" = {
        forceSSL = true;
        serverName = "nas.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # NAS (webdavd) proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "git" = {
        forceSSL = true;
        serverName = "git.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Gitea proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "matrix" = {
        forceSSL = true;
        serverName = "matrix.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Matrix proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.matrix-conduit.settings.global.address}:${toString config.services.matrix-conduit.settings.global.port}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "website" = {
        forceSSL = true;
        serverName = "devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/privkey.pem;
        root = "/var/lib/website/public";
      };
      "search" = {
        forceSSL = true;
        serverName = "search.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # SearX proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.searx.settings.server.bind_address}:${toString config.services.searx.settings.server.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "todo" = {
        forceSSL = true;
        serverName = "todo.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
      };
      "uptime-kuma" = {
        forceSSL = true;
        serverName = "uptime.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Uptime kuma proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.uptime-kuma.settings.HOST}:${toString config.services.uptime-kuma.settings.PORT}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "calibre" = {
        forceSSL = true;
        serverName = "calibre.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Calibre-web proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.calibre-web.listen.ip}:${toString config.services.calibre-web.listen.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "grafana" = {
        forceSSL = true;
        serverName = "grafana.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Grafana proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "headscale" = {
        addSSL = true;
        serverName = "headscale.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Headscale proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
      "microbin" = {
        forceSSL = true;
        serverName = "bin.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Grafana proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.microbin.settings.MICROBIN_BIND}:${toString config.services.microbin.settings.MICROBIN_PORT}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
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

    nftables.enable = true; # use the newer nftables
    # Enable the firewall
    firewall = {
      enable = true;
      rejectPackets = true;
      allowPing = true;

      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];

      # Allowed ports on interface enp9s0
      interfaces.enp9s0 = {
        allowedTCPPorts = [ 80 443 2222 6513 7777 ];
        allowedUDPPorts = [ 7777 ];
      };

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
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "libvirtd" "docker" ]; # Add some groups
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqBEj6Gv7y/7mn8/V4m6hV0j71ClcZ03/xd1CEpDt3qX4iAC/YNioOQJcKoR3ZpJLF+xvfT5pO3fSs0aNmkpGAl9HdRO98qDW23VU0AsOxlSaKmj5/2Y3xCf76rfnr+Hm4bMRbFVtKdzzY9r6L6Fy8rP4Nx0DdOsJmFg11Rfp8jTlKHXJp/zDdZ0zmSxZaIPCdzPMaERCJzonBeDdY7svO7GqRZ0Poo9uW0iMCR/62H7/Gd2UWn2a0x/KKhVquF2UTqBdhZJ401N0hau26KYSXl9/msn5XoXGw4KHGWFUcZHaP/oqktVt5JaalfM60aGtX445GCvUhJ2mQPJbwbn3ZtsA53HP16dQWuj/hLa8gbvHDrwk3rXrDG9aQcgUe4OplrdzHuTAkkoSu6eFwmlioMkCUjLQQzKuCeA+2IlxmZ9fH9lZ4itVXb+rJfx6+XNRA6M/4APBV/f0xK2ua0L2gGQqxVkd4J8aPbiuPtFCKWUv+pFRbnZR444ldl42rtip/XpYfnTSRUwoIutp/PfqasPAQPqLDr5GRKb3Xq93lhUMpfOp+vC0CtDCNmUJT5IQvDWbxARWU1ouS/Jbc5a5w96ZKa1UojXcLSFSL30/f2pXlcjEObTwmtSGlcf7fWdRShgsucoksLm02z6mVPqZPwvYMRZscc78xTf0GDXaCqw== openpgp:0x26D2DBBE"
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
  environment.systemPackages = [
    config.services.headscale.package
    pkgs.dufs
  ];

  # Define the system stateVersion
  system.stateVersion = "23.11";
}
