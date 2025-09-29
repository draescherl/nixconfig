{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (builtins.elem "sway" config.desktops) {
    environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
    security.pam.services.gdm.enableGnomeKeyring = true;

    services.displayManager.gdm.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.xserver.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        brightnessctl
        cliphist
        fuzzel
        networkmanagerapplet
        pavucontrol
        pulseaudio
        sway-contrib.grimshot
        swaybg
        swayidle
        swaylock-effects
        swaynotificationcenter
        tofi
        waybar
        wev
        wl-clipboard
        wlogout
        wlsunset
        wtype
      ];
      extraOptions = lib.optionals config.nvidia.enable [
        "--unsupported-gpu"
      ];
      extraSessionCommands = ''
        eval $(gnome-keyring-daemon --start --daemonize)
      '';
    };
  };
}
