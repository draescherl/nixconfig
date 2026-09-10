{ pkgs, ... }:
{
  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
  ];
}
