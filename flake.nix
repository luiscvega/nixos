{
  description = "NixOS workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    ...
  }: {
    nixosConfigurations.x13-gen2 = nixpkgs.lib.nixosSystem {
      modules = [
        ./hardware-x13-gen2.nix
        ./configuration.nix
        {
          networking.hostName = "x13-gen2";
          system.stateVersion = "24.11";
          nixpkgs.overlays = [
            (_: prev: {
              claude-code =
                (import nixpkgs-unstable {
                  system = prev.system;
                  config.allowUnfree = true;
                })
                .claude-code;
            })
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.luis = ./home.nix;
        }
      ];
    };

    nixosConfigurations.x13-gen3 = nixpkgs.lib.nixosSystem {
      modules = [
        ./hardware-x13-gen3.nix
        ./configuration.nix
        {
          networking.hostName = "x13-gen3";
          system.stateVersion = "26.05";
          nixpkgs.overlays = [
            (_: prev: {
              claude-code =
                (import nixpkgs-unstable {
                  system = prev.system;
                  config.allowUnfree = true;
                })
                .claude-code;
            })
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.luis = ./home.nix;
        }
      ];
    };

    nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
      modules = [
        ./hardware-fw13.nix
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        ./configuration.nix
        {
          networking.hostName = "fw13";
          system.stateVersion = "26.05";
          nixpkgs.overlays = [
            (_: prev: {
              claude-code =
                (import nixpkgs-unstable {
                  system = prev.system;
                  config.allowUnfree = true;
                })
                .claude-code;
            })
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.luis = ./home.nix;
        }
      ];
    };
  };
}
