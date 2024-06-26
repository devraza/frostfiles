{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Stable nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # chaotic
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # 'Vaporise'
    vaporise.url = "github:devraza/vaporise";
    # 'bunbun'
    bunbun.url = "github:devraza/bunbun";

    # Home manager
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other inputs
    musnix.url = "github:musnix/musnix";

    # macOS
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    vaporise,
    home-manager,
    chaotic,
    darwin,
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
          ./workstations.nix
	        ./hosts/endogenesis

          musnix.nixosModules.musnix # real-time audio on NixOS
          chaotic.nixosModules.default # chaotic-nyx

          home-manager.nixosModules.home-manager ({ config, ... }: {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.users.devraza = import ./home;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (config.networking) hostName;

              pkgs-stable = import nixpkgs-stable { system = system; };
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

          chaotic.nixosModules.default # chaotic-nyx

	        home-manager.nixosModules.home-manager ({ config, ... }: {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.devraza = import ./home/icefall;
	        home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit (config.networking) hostName;
          }; })
        ];
      };
    };

    # MacOS nix/home configurations(s)
    darwinConfigurations = {
      elysia = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/elysia

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.devraza = import ./home/elysia;
	          home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };
    };
  };
}
