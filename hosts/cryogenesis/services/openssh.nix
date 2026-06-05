{
  services.openssh = {
    enable = true;
    # Some security settings
    ports = [ 6513 ];
    openFirewall = false;
    allowSFTP = true;
    settings = {
      AllowUsers = [ "devraza" ];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      Banner = "/etc/nixos/assets/banner.txt";
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

      Compression yes
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
