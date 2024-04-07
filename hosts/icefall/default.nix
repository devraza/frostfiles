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
    sudo = {
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

  services.openssh = {
    enable = true;
    # Some security settings
    ports = [
      6513 
    ];
    banner = ''
      Unauthorized access is not permitted, and will result in possible legal action. By accessing this system,
      you acknowledge that you are authorized to do so.

      If you're doing something you aren't meant to be doing, I will find you.
    '';
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
  environment.etc = {
    "fail2ban/filter.d/nginx-bruteforce.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
    '';
    "fail2ban/filter.d/gitea.conf".text = ''
      [Definition]
      failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
      ignoreregex =
    '';
  };
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    ignoreIP = [ "100.64.0.0/24" ];
    jails = {
      "nginx-bruteforce" = '' # A maximum of 6 failures in 600 seconds
        enabled  = true
        filter   = nginx-bruteforce
        logpath  = /var/log/nginx/access.log
        backend  = auto
        maxretry = 6
        findtime = 600
      '';
      "gitea" = ''
        enabled  = true
        filter   = gitea
        logpath  = /var/lib/gitea/log/gitea.log
        maxretry = 6
        bantime  = 600
        findtime = 3600
      '';
    };
  };

  # Torrents
  services.deluge = {
    enable = true;
    web = {
      enable = true;
      port = 8182;
    };
  };

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
      server_url = "https://headscale.devraza.duckdns.org";
      dns_config = {
        base_domain = "devraza.duckdns.org"; 
        nameservers = [ 
          "9.9.9.9"
          "100.64.0.2"
        ];
        domains = [ "devraza.devraza.duckdns.org" "headscale.devraza.duckdns.org" ];
        override_local_dns = true;
      };
      derp.update_frequency = "5m";
    };
  };

  services.tailscale.enable = true;

  # Serve file server
  systemd.services = {
    "dufs" = {
      script = with pkgs; ''
        ${dufs}/bin/dufs -A -a devraza:Rl6KSSPbVHV0QHU1@/:rw -b 0.0.0.0 -p 8090 /mnt/codebreaker
      '';
      serviceConfig = {
        type = "simple";
        user = "root";
      };
      wantedBy = [ "multi-user.target" ];
      after = [
        "networkmanager.service"
        "startup.service"
      ];
    };
    "kiwix" = {
      script = with pkgs; ''
        ${kiwix-tools}/bin/kiwix-serve --port=3920 /mnt/codebreaker/Documents/wikipedia_en_all_maxi_2024-01.zim
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
  };

  # Matrix configuration
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      allow_federation = true;
      port = 8029;
      database_backend = "rocksdb";
      allow_registration = false;
      address = "127.0.0.1";
      server_name = "devraza.duckdns.org";
      enable_lightning_bolt = false;
      trusted_servers = [
        "mozilla.org"
      ];
    };
  };

  # Nginx configuration
  services.nginx = {
    enable = true;
    clientMaxBodySize = "128M";
    # Virtual hosts
    virtualHosts = {
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
      "website" = {
        forceSSL = true;
        serverName = "devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/privkey.pem;
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "matrix.devraza.duckdns.org:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" =  { "base_url" = "https://matrix.devraza.duckdns.org"; };
              "m.identity_server" =  { "base_url" = "https://vector.im"; };
            };
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };
      "matrix" = {
        forceSSL = true;
        serverName = "matrix.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Conduit proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.matrix-conduit.settings.global.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        extraConfig = ''
          listen 8448 ssl http2 default_server;
          listen [::]:8448 ssl http2 default_server;
        '';
      };
      "headscale" = {
        forceSSL = true;
        serverName = "headscale.devraza.duckdns.org";
        sslCertificate = ./services/nginx/certs/subdomains/fullchain.pem;
        sslCertificateKey = ./services/nginx/certs/subdomains/privkey.pem;
        # Headscale proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };
    appendHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
    '';
  };

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
        allowedTCPPorts = [ 80 443 2222 6513 8448 ];
      };

      # Allowed ports on tailscale
      trustedInterfaces = [ "tailscale0" "virbr0" ];
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
