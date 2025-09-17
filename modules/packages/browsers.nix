{ zen, pkgs, ... }:
{
  programs.firefox.enable = true;
  environment.systemPackages = [
    zen.default
    pkgs.chromium
  ];
}
