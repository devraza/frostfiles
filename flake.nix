{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Endogenesis nix/home configuration
    nixosConfigurations = {
      endogenesis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./shared.nix
	        ./hosts/endogenesis
          home-manager.nixosModules.home-manager {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home/devraza/home.nix;
	          home-manager.extraSpecialArgs = inputs;
	        }
        ];
      };

      # Avalanche nix/home configuration
      avalanche = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./shared.nix
	        ./hosts/avalanche
        ];
      };
    };
  };
}
