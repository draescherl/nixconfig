{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, zen-browser, ... }:
    let
      system = "x86_64-linux";

      mkNixosSystem =
        system:
        {
          hostname,
          gaming ? false,
          nvidia ? false,
          work ? false,
          desktops ? [ ],
          ...
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            zen = zen-browser.packages.${system};
            inherit hostname desktops;
            features = {
              gaming.enable = gaming;
              nvidia.enable = nvidia;
              work.enable = work;
            };
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./modules
          ];
        };

      # Host configurations
      hostConfigs = {
        desktop = {
          gaming = true;
          nvidia = true;
          work = true;
          desktops = [
            "gnome"
            "sway"
          ];
        };
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs (
        hostname: config: mkNixosSystem system (config // { inherit hostname; })
      ) hostConfigs;
    };
}
