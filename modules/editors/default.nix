{ pkgs, ... }:
{
  imports = [
    ./neovim.nix
  ];

  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    vscode
    zed-editor-fhs
  ];
}
