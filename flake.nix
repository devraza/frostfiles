{
  inputs = {
    # Use nixos-unstable by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixpkgs master
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # Stable nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/main";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # chaotic
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # 'Vaporise'
    vaporise.url = "github:devraza/vaporise";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      home-manager,
      chaotic,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style; # nix fmt
      # Executed by `nix build .#<name>`
      nixosConfigurations = {
        # Frigidflash nix/home configuration
        frigidflash = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/frigidflash
            ./hosts/workstations.nix
            ./hosts/cachy.nix

            ({ config, pkgs, lib, ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  tetrio-desktop = final.callPackage ./packages/tetrio-desktop.nix { };
                })
              ];

              environment.systemPackages = [
                pkgs.sbctl
              ];

              boot.loader.systemd-boot.enable = lib.mkForce false;
              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            })

            chaotic.nixosModules.default # chaotic-nyx
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
                  pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
                  pkgs-master = import nixpkgs-master { inherit system; };
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
            pkgs-stable = import nixpkgs-stable { inherit system; };
          };
          modules = [
            ./hosts/icefall
            ./hosts/cachy.nix

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
