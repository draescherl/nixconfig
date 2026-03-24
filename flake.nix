{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      zen-browser,
      noctalia-shell,
      mangowm,
      ...
    }:
    let
      # Helper function to create a system configuration
      mkSystem =
        {
          system,
          hostname,
          username,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system hostname username;
            zen = zen-browser.packages.${system}.default;
            noctalia = noctalia-shell.packages.${system}.default;
          };
          modules = [
            # Host-specific configuration
            ./hosts/${hostname}/configuration.nix

            # Common modules shared across all systems
            ./modules/fonts.nix
            ./modules/login.nix
            ./modules/security.nix
            ./modules/system.nix
            ./modules/users.nix
            ./modules/virtualisation.nix
            mangowm.nixosModules.mango
          ]
          ++ extraModules; # Host-specific modules
        };
    in
    {
      nixosConfigurations = {
        # Desktop configuration
        desktop = mkSystem {
          system = "x86_64-linux";
          hostname = "desktop";
          username = "lucas";
          extraModules = [
            ./modules/desktops/mangowc.nix
            ./modules/desktops/sway.nix
            ./modules/keyd.nix
            ./modules/nvidia.nix
          ];
        };
      };
    };
}
