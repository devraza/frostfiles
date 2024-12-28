{
  imports = [
    ./caddy.nix
    ./openssh.nix
    ./fail2ban.nix
    ./systemd.nix
    ./proxy.nix

    ./containers
  ];
}
