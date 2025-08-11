{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (builtins.elem "gnome" config.desktops) {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.xserver.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      cheese
      epiphany
      gnome-console
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-tour
      gnome-usage
      xterm
      yelp
    ];
  };
}
