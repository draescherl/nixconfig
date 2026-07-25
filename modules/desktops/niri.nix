{
  pkgs,
  noctalia,
  ...
}:
{
  programs.niri.enable = true;

  # https://nixos.wiki/wiki/Nautilus
  services.gvfs.enable = true;

  environment.systemPackages = [
    pkgs.adwaita-icon-theme
    pkgs.gnome-text-editor
    pkgs.loupe
    pkgs.nautilus
    pkgs.papers
    pkgs.pulseaudio
    pkgs.vlc
    pkgs.wev
    pkgs.wl-clipboard
    noctalia
  ];
}
