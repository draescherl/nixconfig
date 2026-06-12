{ pkgs, ... }:
{
  # Provides the standalone "Adwaita-dark" GTK theme on disk. Without it,
  # gtk-theme-name=Adwaita-dark resolves to nothing and GTK3 apps
  # (e.g. nm-applet) silently fall back to light Adwaita.
  environment.systemPackages = [ pkgs.gnome-themes-extra ];

  # GTK3 apps read this directly.
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
  '';
  environment.etc."xdg/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
  '';

  # GTK4/libadwaita apps and browsers ignore settings.ini; they ask
  # xdg-desktop-portal for org.freedesktop.appearance color-scheme.
  # xdg-desktop-portal-gtk derives that from this dconf key, so set it
  # system-wide as a default.
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
          };
        };
      }
    ];
  };

  # Under Sway (XDG_CURRENT_DESKTOP=sway) the gtk portal isn't picked up
  # automatically (it declares UseIn=gnome), so route the Settings
  # interface to it explicitly. This is what feeds color-scheme to apps.
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common."org.freedesktop.impl.portal.Settings" = [ "gtk" ];
  };
}
