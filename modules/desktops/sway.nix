{
  pkgs,
  noctalia,
  ...
}:
{
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
    extraPackages = [
      pkgs.adwaita-icon-theme
      pkgs.gnome-text-editor
      pkgs.loupe
      pkgs.nautilus
      pkgs.papers
      pkgs.sway-contrib.grimshot
      pkgs.vlc
      pkgs.wev
      pkgs.wl-clipboard
      noctalia
    ];
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}
