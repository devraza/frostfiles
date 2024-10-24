{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Stable nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # chaotic
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # 'Vaporise'
    vaporise.url = "github:devraza/vaporise";
    # 'bunbun'
    bunbun.url = "github:devraza/bunbun";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other inputs
    musnix.url = "github:musnix/musnix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      vaporise,
      home-manager,
      chaotic,
      musnix,
      ...
    }@inputs:
    {
      # Executed by `nix build .#<name>`
      nixosConfigurations = {
        # Frigidslash nix/home configuration
        frigidslash = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/frigidslash
	          ./workstations.nix

            chaotic.nixosModules.default # chaotic-nyx
	          musnix.nixosModules.musnix # real-time audio on NixOS

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.devraza = import ./home;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit (config.networking) hostName;
                };
              }
            )
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

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.devraza = import ./home/icefall;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit (config.networking) hostName;
                };
              }
            )
          ];
        };

        # thermogenesis nix/home configuration
        thermogenesis = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/thermogenesis

            chaotic.nixosModules.default # chaotic-nyx

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.devraza = import ./home/icefall;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit (config.networking) hostName;
                };
              }
            )
          ];
        };
      };
    };
}
