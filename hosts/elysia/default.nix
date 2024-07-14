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
  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };

  # Allow TouchID for `sudo`
  security.pam.enableSudoTouchIdAuth = true;

  # Specify networking services to configure
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "ProtonVPN"
  ];

  # User
  users.users.devraza = {
    name = "devraza";
    home = "/Users/devraza";
  };
}
