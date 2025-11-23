{ username, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd sway";
        user = username;
      };
    };
  };

  hardware.graphics.enable = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

  # https://nixos.wiki/wiki/Nautilus
  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
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
      waybar
      wev
      wl-clipboard
      wlogout
      wlsunset
      wtype
    ];
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}
