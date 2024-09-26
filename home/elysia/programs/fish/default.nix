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

      # Homebrew
      fish_add_path /opt/homebrew/bin
      # libiconv
      fish_add_path /opt/homebrew/opt/libiconv/bin
      set -gx LDFLAGS "-L/opt/homebrew/opt/libiconv/lib"

      # Add nix binaries to PATH
      fish_add_path /etc/profiles/per-user/devraza/bin
      function removepath
          set -x PATH /Users/devraza/.local/bin /opt/homebrew/opt/libiconv/bin /opt/homebrew/bin /usr/local/bin /System/Cryptexes/App/usr/bin /usr/bin /bin /usr/sbin /sbin /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin /Applications/Wireshark.app/Contents/MacOS /Users/devraza/.cargo/bin
          echo "Updated $PATH successfully"
      end

      # HiDPI
      set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
      set -x MOZ_ENABLE_WAYLAND 1
      set -x GTK_USE_PORTAL 0

      # Set cache directory
      set -x XDG_CACHE_HOME ~/.cache

      # Disable the greeting
      set fish_greeting

      # Japanese
      set -x QT_IM_MODULE "fcitx"
      set -x XMODIFIERS "@im=fcitx"
      set -x GTK_IM_MODULE "fcitx"

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
      "vpnc" = "sudo protonvpn c -p udp -f";
      "vpnd" = "sudo protonvpn d";
      "ps" = "procs";
      "rm" = "vpr";
    };
  };
}
