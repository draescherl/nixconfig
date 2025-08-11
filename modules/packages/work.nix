{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    work.enable = lib.mkEnableOption "enables tools required for work";
  };

  config = lib.mkIf config.work.enable {
    environment.systemPackages = with pkgs; [
      _1password-cli
      clever-tools
      slack
    ];
  };
}
