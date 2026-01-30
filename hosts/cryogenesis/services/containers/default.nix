{
  imports = [
    ./vaultwarden.nix
    ./homepage.nix
    ./forgejo.nix
    ./redlib.nix
    ./navidrome.nix
  ];
  
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
}
