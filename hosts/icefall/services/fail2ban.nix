{
  # Fail2Ban configuration
  environment.etc = {
    /*
      "fail2ban/filter.d/caddy.conf".text = ''
        [Definition]
        failregex = ^.*"remote_ip":"<HOST>",.*?"status":(?:401|403|500),.*$
        ignoreregex =
        datepattern = LongEpoch
      '';
    */
    "fail2ban/filter.d/forgejo.conf".text = ''
      [Definition]
      failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
      ignoreregex =
    '';
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
    ignoreIP = [ "100.64.0.0/24" ];
    jails = {
      /*
              "caddy" = '' # A maximum of 5 failures in 1 hour
                enabled  = true
                filter   = caddy
        	      port     = http,https
                logpath  = /var/log/caddy/*.log
                backend  = auto
                maxretry = 5
                findtime = 3600
              '';
      */
      "forgejo" = ''
        enabled  = true
        filter   = forgejo
        logpath  = /var/lib/git/log/forgejo.log
        maxretry = 5
        findtime = 3600
      '';
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
