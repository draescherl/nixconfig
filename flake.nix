{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      zen-browser,
      ...
    }:
    let
      system = "x86_64-linux";
      args = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs args;
      zen = zen-browser.packages.${system};
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = {
            inherit zen;
            hostname = "nixos";
          };
          modules = [
            ./hosts/desktop/configuration.nix
            ./modules
          ];
        };
      };
    };
}
