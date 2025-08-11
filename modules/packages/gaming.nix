{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    gaming.enable = lib.mkEnableOption "enables gaming support";
  };

  config = lib.mkIf config.gaming.enable {
    programs.steam.enable = true;
  };
}
