{ pkgs, ... }: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    sshKeys = [
      "4C00B84E9C63D4ED01382BF739C1AFC7F2454060"
    ];
  };
}
