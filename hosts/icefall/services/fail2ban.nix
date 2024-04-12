{
  # Fail2Ban configuration
  environment.etc = {
    "fail2ban/filter.d/nginx-bruteforce.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*GET.*(matrix/server|\.php|admin|wp\-).* HTTP/\d.\d\" 404.*$
    '';
    "fail2ban/filter.d/gitea.conf".text = ''
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
    ignoreIP = [ "100.64.0.0/24" ];
    jails = {
      "nginx-bruteforce" = '' # A maximum of 6 failures in 600 seconds
        enabled  = true
        filter   = nginx-bruteforce
        logpath  = /var/log/nginx/access.log
        backend  = auto
        maxretry = 6
        findtime = 600
      '';
      "gitea" = ''
        enabled  = true
        filter   = gitea
        logpath  = /var/lib/gitea/log/gitea.log
        maxretry = 6
        bantime  = 600
        findtime = 3600
      '';
      "vaultwarden" = ''
        enabled  = true
        filter   = vaultwarden
        logpath  = /var/lib/vaultwarden/vaultwarden.log
        maxretry = 6
        bantime  = 600
        findtime = 3600
      '';
    };
  };
}
