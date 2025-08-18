{
  # Fail2Ban configuration
  environment.etc = {
    "fail2ban/filter.d/vaultwarden.conf".text = ''
      [Definition]
      failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
      ignoreregex =
    '';
  };
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    bantime-increment.enable = true;
    ignoreIP = [ "100.108.0.0/16" ];
    jails = {
      "vaultwarden" = ''
        enabled  = true
        filter   = vaultwarden
        port     = 80,443,8081
        banaction = %(banaction_allports)s
        logpath  = /var/lib/vaultwarden/vaultwarden.log
        maxretry = 5
        findtime = 3600
      '';
    };
  };
}
