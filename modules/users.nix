{
  username,
  pkgs,
  ...
}:
{
  users.users.${username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = username;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
