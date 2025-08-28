{
  config,
  pkgs-stable,
  pkgs-master,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home = {
    # Home configuration
    username = "devraza";
    homeDirectory = "/home/devraza";

    stateVersion = "23.05";
    # Define packages
    packages = with pkgs; [
      # Misc. Applications
      thunderbird # e-mail
      celluloid # video
      gimp # image editor
      evince # document viewer
      (pkgs.obsidian.overrideAttrs (e: rec {
        desktopItem = e.desktopItem.override (d: {
          exec = "${d.exec} -enable-features=UseOzonePlatform -ozone-platform=wayland";
        });
        installPhase = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.installPhase;
      })) # Obsidian
      transmission_4-gtk # torrent
      jellyfin-media-player # jellyfin client
      (pkgs.signal-desktop.overrideAttrs (e: rec {
        desktopItem = e.desktopItem.override (d: {
          exec = "${d.exec} -enable-features=UseOzonePlatform -ozone-platform=wayland";
        });
        installPhase = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.installPhase;
      })) # comms
      libreoffice # office suite
      krita # 2D art
      foliate # e-book reader
      inkscape # vector editor
      blender # 3D
      firefox # web browser
      bitwarden # password manager
      rnote # handwritten notes
      anki-bin # flashcards
      virtiofsd # VM filesystem share

      # Misc. CLI/TUI Tools
      glxinfo # mesa stuff
      just # command runner
      appimage-run # simple, run appimages
      procs # ps replacement
      sd # sed replacement
      bat # cat replacement
      tokei # lines of code
      yt-dlp # YT downloader
      ffmpeg # a lot
      glow # markdown renderer for the terminal
      ani-cli # anime from the terminal
      fd # find replacement
      du-dust # du replacement
      eza # ls replacement
      brightnessctl # monitor brightness
      bc # math
      ripgrep # grep replacement
      ouch # painless compression/decompression
      bunbun # CLI fetch tool
      bottom # system top
      rustscan # network mapper
      dogdns # dig replacement
      gnome-obfuscate # censor private information
      inputs.vaporise.packages.${pkgs.system}.default # `rm` alternative

      # Typst
      typst # a better LaTeX
      typstfmt # formatting for Typst

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gnupg # GnuPG

      # System/Wayland
      imv # image viewer
      libnotify # notification library
      xdg-utils # utilties for the XDG desktop standard
      wl-clipboard # wayland clipboard

      # Programming
      go
      gopls
      gotools
      rustup
      python3
      clang

      # Fonts
      nerd-fonts.jetbrains-mono # hyprpanel
    ];

    # Environment variables
    sessionVariables = {
      EDITOR = "neovide";
    };
  };

  fonts.fontconfig.enable = true; # enable fontconfig

  # dconf configuration
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Protonmail bridge
  systemd.user.services.hydroxide = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "hydroxide" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.hydroxide}/bin/hydroxide -disable-carddav serve
      ''}";
    };
  };

  # Fix the cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Install custom fonts
  xdg.dataFile."fonts/cartograph".source = ../assets/fonts/cartograph;

  # Imports
  imports = [
    ./programs # programs
    ./services # services
    ./scripts # scripts
  ];
}
