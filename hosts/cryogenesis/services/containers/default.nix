{
  imports = [
    ./vaultwarden.nix
    ./homepage.nix
    ./forgejo.nix
    ./redlib.nix
    ./navidrome.nix
    ./feishin.nix
  ];
  
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
}
