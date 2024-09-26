{ config, pkgs, ... }:
{
  environment = {
    systemPackages = [ pkgs.neovim ];
    shells = [ pkgs.fish ];
 };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow falsely unsupported packages
  nixpkgs.config.allowUnsupportedSystem = true;

  # Tailscale
  services.tailscale.enable = true;

  # Allow TouchID for `sudo`
  security.pam.enableSudoTouchIdAuth = true;

  # Specify networking services to configure
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "ProtonVPN"
  ];

  # MacOS
  services.yabai = {
    enable = true;
    extraConfig = ''
      yabai -m config layout bsp
      yabai -m config top_padding 10
      yabai -m config bottom_padding 10
      yabai -m config left_padding 10
      yabai -m config right_padding 10
      yabai -m config window_gap 10

      # Remove window shadows
      yabai -m config window_shadow off

      # Spaces
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create

      yabai -m config external_bar all:0:32
      yabai -m rule --add app!="^(alacritty|Microsoft OneNote|LibreWolf|.neovide-wrapped|Obsidian|Signal)$" manage=off 
    '';
  };
  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - return : alacritty
      alt - e : neovide
      alt - b : qutebrowser
      alt - a : alacritty -e joshuto

      alt - 1: yabai -m space --focus 1
      alt - 2: yabai -m space --focus 2
      alt - 3: yabai -m space --focus 3
      alt - 4: yabai -m space --focus 4
      alt - 5: yabai -m space --focus 5
      alt - 6: yabai -m space --focus 6
      alt - 7: yabai -m space --focus 7
      alt - 8: yabai -m space --focus 8

      alt + shift - 1: yabai -m window --space 1
      alt + shift - 2: yabai -m window --space 2
      alt + shift - 3: yabai -m window --space 3
      alt + shift - 4: yabai -m window --space 4
      alt + shift - 5: yabai -m window --space 5
      alt + shift - 6: yabai -m window --space 6
      alt + shift - 7: yabai -m window --space 7
      alt + shift - 8: yabai -m window --space 8

      alt - h: yabai -m window --focus west
      alt - j: yabai -m window --focus south
      alt - k: yabai -m window --focus north
      alt - l: yabai -m window --focus east

      alt + shift - h: yabai -m window --swap west
      alt + shift - j: yabai -m window --swap south
      alt + shift - k: yabai -m window --swap north
      alt + shift - l: yabai -m window --swap east

      cmd - h: yabai -m display --focus west
      cmd - l: yabai -m display --focus east
    '';
  };



  # User
  users.users.devraza = {
    name = "devraza";
    home = "/Users/devraza";
  };
}
