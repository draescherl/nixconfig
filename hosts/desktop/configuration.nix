{ pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = hostname;
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    _1password-cli
    slack
    stremio
  ];

  nvidia.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
