{ pkgs, ... }: {
  # https://nixos.wiki/wiki/Nautilus
  services.gvfs.enable = true;

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    cliphist
    fuzzel
    gnome-text-editor
    loupe
    mako
    nautilus
    networkmanagerapplet
    papers
    pavucontrol
    pulseaudio
    swaybg
    swaylock
    vlc
    waybar
    wev
    wl-clipboard
    wleave
    wlsunset
    wtype
  ];
}
