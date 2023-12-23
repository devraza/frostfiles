# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, lib, ... }:

{
  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader configuration (grub)
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest; # Use the linux-zen kernel by default
    kernelParams = [ "quiet" "splash" "intel_pstate=disable" ];
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
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true; # Optimise the nix store
      allowed-users = [ "@wheel" ]; # only allow those in the `wheel` group to use the package manager
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Create a swapfile
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }];

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

  # autoUpgrade for a flake-enabled system
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    dates = "weekly";
  };

  time.timeZone = "Europe/London"; # Set time zone.

  # Security
  security = {
    rtkit.enable = true; # make PipeWire real-time capable
    pam.services.waylock = { };
  };

  services.openssh = {
    enable = true;
    # Some security settings
    settings = {
      AllowUsers = [ "devraza" ];
      PermitRootLogin = "no";
    };
  };

  # Fail2Ban configuration
  services.fail2ban = {
    enable = true;
    bantime = "10m";
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
        root_url = "http://127.0.0.1/grafana/";
        serve_from_sub_path = true;
      };
    };
  };
  
  # Gitea configuration
  services.gitea = {
    enable = true;
    settings = {
      APP_NAME = "Devraza's git repositories";
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
        ROOT_URL = "http://127.0.0.1/";
        START_SSH_SERVER = true;
      };
    };
    user = "gitea";
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

  # Nginx configuration
  services.nginx = {
    enable = true;
    # Virtual hosts
    virtualHosts = {
      # Localhost proxies
      "localhost" = {
        addSSL = true;
        sslCertificate = ./services/nginx/certs/host.pem;
        sslCertificateKey = ./services/nginx/certs/host.key;
        # Gitea proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        # Grafana proxy
        locations."/grafana/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
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

    # Enable the firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 8082 2222 ];
    };

    interfaces.enp9s0.ipv4.addresses = [ {
      address = "192.168.1.246";
      prefixLength = 24;
    } ]; 

    defaultGateway = "192.168.1.254";
    nameservers = [
      "kevin.ns.cloudflare.com"
      "savanna.ns.cloudflare.com"
    ];

    networkmanager.enable = true;
    # disable IPv6
    enableIPv6 = false;
  };

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
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ]; # Add some groups
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqBEj6Gv7y/7mn8/V4m6hV0j71ClcZ03/xd1CEpDt3qX4iAC/YNioOQJcKoR3ZpJLF+xvfT5pO3fSs0aNmkpGAl9HdRO98qDW23VU0AsOxlSaKmj5/2Y3xCf76rfnr+Hm4bMRbFVtKdzzY9r6L6Fy8rP4Nx0DdOsJmFg11Rfp8jTlKHXJp/zDdZ0zmSxZaIPCdzPMaERCJzonBeDdY7svO7GqRZ0Poo9uW0iMCR/62H7/Gd2UWn2a0x/KKhVquF2UTqBdhZJ401N0hau26KYSXl9/msn5XoXGw4KHGWFUcZHaP/oqktVt5JaalfM60aGtX445GCvUhJ2mQPJbwbn3ZtsA53HP16dQWuj/hLa8gbvHDrwk3rXrDG9aQcgUe4OplrdzHuTAkkoSu6eFwmlioMkCUjLQQzKuCeA+2IlxmZ9fH9lZ4itVXb+rJfx6+XNRA6M/4APBV/f0xK2ua0L2gGQqxVkd4J8aPbiuPtFCKWUv+pFRbnZR444ldl42rtip/XpYfnTSRUwoIutp/PfqasPAQPqLDr5GRKb3Xq93lhUMpfOp+vC0CtDCNmUJT5IQvDWbxARWU1ouS/Jbc5a5w96ZKa1UojXcLSFSL30/f2pXlcjEObTwmtSGlcf7fWdRShgsucoksLm02z6mVPqZPwvYMRZscc78xTf0GDXaCqw== openpgp:0x26D2DBBE"
    ];
  };

  # Enable and make 'fish' the default user shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # uPower
  services.upower.enable = true;

  # Real-time audio for NixOS
  musnix.enable = true;

  # Enable the usage of clamav - virus scanner
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # DBus service for automounting disks
  services.udisks2.enable = true;

  # Define the system stateVersion
  system.stateVersion = "23.11";
}
