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
    programs._1password.enable = true;
    programs._1password-gui.enable = true;
    programs._1password-gui.polkitPolicyOwners = [ "lucas" ];

    environment.systemPackages = with pkgs; [
      clever-tools
      slack
    ];
  };
}
