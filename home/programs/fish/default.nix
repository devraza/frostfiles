{
  # Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if status is-interactive
         starship init fish | source
      end

      # Wayland/DPI fixing
      set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
      set -x ANKI_WAYLAND 1
      set -x MOZ_ENABLE_WAYLAND 1
      set -x GTK_USE_PORTAL 0

      # Set cache directory
      set -x XDG_CACHE_HOME ~/.cache

      # Start wayland on login
      if status is-login
        if test (tty) = /dev/tty1
          exec start-hyprland
        end
      end

      # Disable the greeting
      set fish_greeting

      # Use GPG agent instead of SSH agent for authentication
      set -x SSH_AUTH_SOCK /run/user/$EUID/gnupg/S.gpg-agent.ssh

      function starship_transient_prompt_func
        echo "\$ "
      end
    '';
    shellAliases = {
      ".1" = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      "mkdir" = "mkdir -p";
      "ls" = "eza -1l --sort=size";
      "l" = "eza -1al --sort=size";
      "sed" = "sd";
      "cat" = "bat";
      "ps" = "procs";
      "rm" = "vpr";
    };
  };
}
