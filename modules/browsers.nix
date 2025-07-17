{ zen, ... }:
{
  programs.firefox.enable = true;
  environment.systemPackages = [
    zen.default
  ];
}
