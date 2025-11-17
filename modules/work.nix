{ username, pkgs, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ username ];

  users.users.${username}.packages = with pkgs; [
    clever-tools
    slack
  ];
}
