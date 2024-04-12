{
  services.openssh = {
    enable = true;
    # Some security settings
    ports = [
      6513 
    ];
    banner = ''
      Unauthorized access is not permitted, and will result in possible legal action.
      By accessing this system, you acknowledge that you are authorized to do so.

      If you're doing something you aren't meant to be doing, I will find you.

    '';
    openFirewall = false;
    allowSFTP = false;
    settings = {
      AllowUsers = [ "devraza" ];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      PermitUserEnvironment no # Disable changing environment variables
      
      UseDNS yes # verify hostname and IP matches
      Protocol 2 # Use the newer SSH protocol only

      # Disable port forwarding
      AllowTcpForwarding no
      AllowStreamLocalForwarding no
      GatewayPorts no
      PermitTunnel no

      Compression no
      TCPKeepAlive no
      AllowAgentForwarding no

      # Disable rhosts
      IgnoreRhosts yes
      HostbasedAuthentication no

      # Other
      LoginGraceTime 20
      MaxSessions 2
      MaxStartups 2
    '';
  };
}
