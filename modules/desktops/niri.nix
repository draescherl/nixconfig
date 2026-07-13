{
  pkgs,
  username,
  noctalia,
  ...
}:
{
  environment.etc = {
    "custom-sessions/niri-noctalia.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Niri (Noctalia Shell)
        Exec=niri --session -c /home/${username}/.config/niri/noctalia.kdl
        Type=Application
        DesktopNames=niri
      '';
    };
  };

  # https://nixos.wiki/wiki/Nautilus
  services.gvfs.enable = true;

  programs.niri.enable = true;

  environment.systemPackages =
    with pkgs;
    [
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
    ]
    ++ [
      noctalia
    ];
}
