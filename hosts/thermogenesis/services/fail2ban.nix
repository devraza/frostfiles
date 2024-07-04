{
  # Fail2Ban configuration
  environment.etc = {
    "fail2ban/filter.d/forgejo.conf".text = ''
      [Definition]
      failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
      ignoreregex =
    '';
  };
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    bantime-increment.enable = true;
    ignoreIP = [ "100.64.0.0/24" ];
    jails = {
      "forgejo" = ''
        enabled  = true
        filter   = forgejo
        logpath  = /var/lib/git/log/forgejo.log
        maxretry = 5
        findtime = 3600
      '';
    };
  };
}
