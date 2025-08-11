{ pkgs, ... }:
{
  users.users.lucas = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "lucas";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };
}
