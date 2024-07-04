{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry_mac;
  };
}
