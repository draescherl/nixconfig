{ pkgs, ... }:
{
  imports = [
    ./browsers.nix
    ./email.nix
    ./gaming.nix
    ./shells.nix
    ./work.nix
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    bitwarden-cli
    bitwarden-desktop
    delta
    dig
    direnv
    eza
    fd
    fzf
    gcc
    git
    git-lfs
    gnumake
    go-task
    htop
    jq
    nix-direnv
    postgresql
    pspg
    ripgrep
    sd
    solaar
    starship
    stow
    vesktop
    wezterm
    wget
    wireguard-tools
    zoxide
  ];
}
