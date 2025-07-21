{
  pkgs,
  lib,
  config,
  ...
}:
{
  hardware.graphics.enable = true;

  services.printing.enable = true;

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      cliphist
      networkmanagerapplet
      pavucontrol
      pulseaudio
      sway-contrib.grimshot
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
}
