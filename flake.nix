{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Endogenesis nix/home configuration
    # Executed by `nix build .#<name>`
    packages."<system>"."<name>" = derivation;
    nixosConfigurations = {
      endogenesis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./shared.nix
	        ./hosts/endogenesis
          home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home/devraza/home.nix;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (config.networking) hostName;
            };
	        })
        ];
      };

      # Avalanche nix/home configuration
      avalanche = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./shared.nix
	        ./hosts/avalanche
	        home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home/devraza/home.nix;
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
