{
  imports = [
    ./vaultwarden.nix
    ./homepage.nix
    ./forgejo.nix
    ./adguard.nix
    ./navidrome.nix
    ./feishin.nix
  ];

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
}
