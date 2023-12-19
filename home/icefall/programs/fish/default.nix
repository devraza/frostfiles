{
  # Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if status is-interactive
         starship init fish | source
      end
  
      # Add nix binaries to PATH
      fish_add_path ~/.nix-profile/bin

      # Set cache directory
      set -x XDG_CACHE_HOME ~/.cache

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
    };
  };
}
