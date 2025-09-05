{ pkgs, ... }:
{
  imports = [
    ./browsers.nix
    ./email.nix
    ./gaming.nix
    ./shells.nix
    ./work.nix
  ];

  programs.direnv = {
    enable = true;
    settings = {
      global = {
        warn_timeout = 0;
        hide_env_diff = true;
      };

      whitelist = {
        prefix = [ "~/Documents/" ];
      };
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    wezterm
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
    postgresql
    pspg
    ripgrep
    sd
    solaar
    starship
    stow
    vesktop
    wget
    wireguard-tools
    zoxide
  ];
}
