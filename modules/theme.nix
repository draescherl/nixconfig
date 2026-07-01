{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gnome-themes-extra ];

  # For GTK3 apps.
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
  '';

  # For GTK4 apps that read settings.ini.
  environment.etc."xdg/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
  '';

  # For GTK4/libadwaita apps that request org.freedesktop.appearance
  # through xdg-desktop-portal-gtk.
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
}
