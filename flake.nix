{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Stable nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 'Vaporise'
    vaporise.url = "github:devraza/vaporise";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland compositor
    mangowm.url = "github:mangowm/mango/f10b2f9f8476e3657e15b700f7075ae701dfe704";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Music player
    kopuz.url = "github:temidaradev/kopuz";

    # For the CachyOS kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      lanzaboote,
      vaporise,
      mangowm,
      nur,
      nix-cachyos-kernel,
      home-manager,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt; # nix fmt
      # Executed by `nix build .#<name>`
      nixosConfigurations = {
        # Frigidflash nix/home configuration
        frigidflash = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            inherit inputs;
          };

          modules = [
            ./hosts/frigidflash
            ./hosts/workstations.nix
            ./hosts/cachy.nix

            nur.modules.nixos.default # nix user repository
            mangowm.nixosModules.mango # system mangowm module 
            lanzaboote.nixosModules.lanzaboote # secure boot
            nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5 # preset

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.devraza = import ./home;
                home-manager.extraSpecialArgs = {
                  pkgs-stable = import nixpkgs-stable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  inherit inputs;
                };
              }
            )
          ];
        };

        # Cryogenesis nix/home configuration
        cryogenesis = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            pkgs-stable = import nixpkgs-stable { inherit system; };
          };
          modules = [
            ./hosts/cryogenesis
            ./hosts/cachy.nix

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.devraza = import ./home/cryogenesis;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                };
              }
            )
          ];
        };
      };
    };
}
