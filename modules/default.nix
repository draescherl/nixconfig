{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.direnv.enable = true;
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
    btop
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
    jq
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

  imports = [
    ./audio.nix
    ./boot.nix
    ./browsers.nix
    ./desktop-environments.nix
    ./editors.nix
    ./gpg.nix
    ./locale.nix
    ./networking.nix
    ./nvidia.nix
    ./shells.nix
    ./users.nix
  ];
}
