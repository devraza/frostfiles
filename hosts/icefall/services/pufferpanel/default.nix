{ pkgs, ... }:
{
  # Game server management
  services.pufferpanel = {
    enable = true;
    extraPackages = with pkgs; [
      temurin-jre-bin-17
      unzip
      gnutar
    ];
    environment = {
      PUFFER_WEB_HOST = "0.0.0.0:9291";
      PUFFER_DAEMON_SFTP_HOST = "0.0.0.0:5657";
      PUFFER_DAEMON_CONSOLE_BUFFER = "1000";
      PUFFER_DAEMON_CONSOLE_FORWARD = "true";
      PUFFER_PANEL_REGISTRATIONENABLED = "false";
    };
  };
}
