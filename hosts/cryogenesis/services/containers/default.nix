{
  imports = [
    ./vaultwarden.nix
    ./homepage.nix
    ./forgejo.nix
    ./redlib.nix
    ./adguard.nix
    ./navidrome.nix
    ./seanime.nix
    ./feishin.nix
  ];
  
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
}
