{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, nixos-hardware, musnix, ... }@inputs: {
    # Endogenesis nix/home configuration
    # Executed by `nix build .#<name>`
    nixosConfigurations = {
      endogenesis = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./shared.nix
	        ./hosts/endogenesis

          nixos-hardware.nixosModules.microsoft-surface-common # Load the common linux-surface modules
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
    };
  };
}
