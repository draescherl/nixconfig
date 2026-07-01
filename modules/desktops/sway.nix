{
  username,
  pkgs,
  ...
}:
{
  environment.etc = {
    "custom-sessions/sway-noctalia.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Sway (Noctalia Shell)
        Exec=sway --config /home/${username}/.config/sway/noctalia
        Type=Application
        DesktopNames=sway;wlroots;swayfx
      '';
    };
  };

  hardware.graphics.enable = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  services.gnome.gnome-keyring.enable = true;

  # https://nixos.wiki/wiki/Nautilus
  services.gvfs.enable = true;

  # Under Sway (XDG_CURRENT_DESKTOP=sway) the gtk portal isn't picked up
  # automatically (it declares UseIn=gnome), so route the Settings
  # interface to it explicitly. This is what feeds color-scheme to apps.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common."org.freedesktop.impl.portal.Settings" = [ "gtk" ];
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraPackages =
      with pkgs;
      [
        adwaita-icon-theme
        brightnessctl
        cliphist
        fuzzel
        gnome-text-editor
        loupe
        nautilus
        networkmanagerapplet
        papers
        pavucontrol
        pulseaudio
        sway-contrib.grimshot
        swaybg
        swayidle
        swaylock-effects
        swaynotificationcenter
        vlc
        waybar
        wev
        wl-clipboard
        wlogout
        wlsunset
        wtype
      ]
      ++ [
        noctalia-shell
      ];
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}
