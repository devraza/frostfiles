{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Stable nixpkgs input
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Inputs ...
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    musnix.url = "github:musnix/musnix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-hardware,
    musnix,
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
              pkgs-stable = import nixpkgs-stable {
                system = system;
                config.allowUnfree = true;
              };
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
    };
  };
}
