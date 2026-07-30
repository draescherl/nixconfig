{
  config,
  pkgs,
  ...
}:
{
  # Enable and unlock the gnome-keyring login keyring at greetd login.
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session =
        let
          sessions_dir = "${config.services.displayManager.sessionData.desktops}/share";
          xsessions = "${sessions_dir}/xsessions";
          wayland_sessions = "${sessions_dir}/wayland-sessions";
          custom_sessions = "/etc/custom-sessions";
          sessions = "${custom_sessions}:${xsessions}:${wayland_sessions}";
        in
        {
          command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${sessions} --remember --remember-user-session";
        };
    };
  };
}
