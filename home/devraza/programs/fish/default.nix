{
  # Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if status is-interactive
         starship init fish | source
      end
  
      # HyprWM lutris workaround
      fish_add_path ~/.config/scripts/wrappers/

      # Add local binaries to the PATH
      fish_add_path ~/.local/bin

      # Add nix binaries to PATH
      fish_add_path ~/.nix-profile/bin

      # HiDPI
      set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
      set -x MOZ_ENABLE_WAYLAND 1
      set -x GTK_USE_PORTAL 0

      # Set cache directory
      set -x XDG_CACHE_HOME ~/.cache

      # Start wayland on login
      if status is-login
         Hyprland
      end

      # Disable the greeting
      set fish_greeting

      # Japanese
      set -x GTK_IM_MODULE "fcitx"
      set -x QT_IM_MODULE "fcitx"
      set -x XMODIFIERS "@im=fcitx"

      # Use GPG agent instead of SSH agent for authentication
      set -x SSH_AUTH_SOCK /run/user/$EUID/gnupg/S.gpg-agent.ssh

      function starship_transient_prompt_func
        echo "\$\ "
      end
    '';
    shellAliases = {
      ".1" = "cd ..";
      ".2" = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      "mkdir" = "mkdir -p";
      "ls" = "exa -1l --sort=size";
      "l" = "exa -1al --sort=size";
    };
  };
}
