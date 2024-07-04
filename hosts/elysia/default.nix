{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.neovim ];

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

  # User
  users.users.devraza = {
    name = "devraza";
    home = "/Users/devraza";
  };
}
