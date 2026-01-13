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
      mpv # video
      gimp # image editor
      evince # document viewer
      (pkgs.obsidian.overrideAttrs (e: rec {
        desktopItem = e.desktopItem.override (d: {
          exec = "${d.exec} -enable-features=UseOzonePlatform -ozone-platform=wayland";
        });
        installPhase = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.installPhase;
      })) # Obsidian
      transmission_4-gtk # torrent
      tsukimi # jellyfin client
      gurk-rs # signal client
      vesktop # Discord client
      rnote # handwritten notes
      libreoffice # office suite
      krita # 2D art
      foliate # e-book reader
      pkgs-stable.aseprite # spriting
      inkscape # vector editor
      blender # 3D
      firefox # web browser
      bitwarden-desktop # password manager
      anki-bin # flashcards

      # Misc. CLI/TUI Tools
      mesa-demos # mesa stuff
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
      steam-run # FHS environment
      dust # du replacement
      eza # ls replacement
      brightnessctl # monitor brightness
      bc # math
      ripgrep # grep replacement
      ouch # painless compression/decompression
      bunbun # CLI fetch tool
      bottom # system top
      rustscan # network mapper
      doggo # dig replacement
      gnome-obfuscate # censor private information
      inputs.vaporise.packages.${pkgs.system}.default # `rm` alternative

      # Typst
      typst # a better LaTeX
      typstyle # formatting for Typst

      # Authentication
      seatd # user seat management
      polkit_gnome # polkit agent
      gnupg # GnuPG

      # System/Wayland
      eog # image viewer
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
      rounded-mgenplus # jp font
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

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/webp" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
    };
  };
}
