{
  pkgs,
  lib,
  config,
  ...
}:
{
  # need to sort through the utility of these
  hardware.graphics.enable = true;
  services.printing.enable = true;
  services.xserver.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            rightcontrol = "layer(meta)";
          };
        };
      };
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  services.displayManager.gdm.enable = true;
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
      export ELECTRON_OZONE_PLATFORM_HINT="auto"
      eval $(gnome-keyring-daemon --start --daemonize)
    '';
  };

  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    fuzzel
    xwayland-satellite
  ];
}
