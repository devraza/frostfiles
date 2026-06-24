{
  # Add binary caches
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixpkgs master
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
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
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System shell
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For the CachyOS kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-master,
      nixos-hardware,
      lanzaboote,
      vaporise,
      mangowm,
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

            (
              {
                config,
                pkgs,
                lib,
                ...
              }:
              {
                environment.systemPackages = [
                  pkgs.sbctl
                ];

                boot.loader.systemd-boot.enable = lib.mkForce false;
                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )

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
                  pkgs-master = import nixpkgs-master { inherit system; };
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
