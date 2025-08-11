{ pkgs, ... }:
{
  programs.fish.enable = true;
  environment.systemPackages = [
    pkgs.fish
    pkgs.nushell
    pkgs.nushellPlugins.formats
  ];
}
