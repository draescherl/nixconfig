{ pkgs, ... }:
{
  hardware.graphics.enable = true;
  services.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.desktopManager.gnome.enable = true;

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
}
