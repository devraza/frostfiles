{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other inputs
    musnix.url = "github:musnix/musnix";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    musnix,
    nix-alien,
    ...
  }@inputs: {
    # Endogenesis nix/home configuration
    # Executed by `nix build .#<name>`
    nixosConfigurations = {
      endogenesis = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./shared.nix
	        ./hosts/endogenesis

          musnix.nixosModules.musnix # real-time audio on NixOS

          home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (config.networking) hostName;
            };
          })
        ];
      };

      # Avalanche nix/home configuration
      avalanche = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./shared.nix
	        ./hosts/avalanche

          musnix.nixosModules.musnix # real-time audio on NixOS

	        home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (config.networking) hostName;
            };
	        })
        ];
      };

      # Icefall nix/home configuration
      icefall = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
	        ./hosts/icefall

          musnix.nixosModules.musnix # real-time audio on NixOS

	        home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home/icefall;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (config.networking) hostName;
            };
	        })
        ];
      };
    };
  };
}
