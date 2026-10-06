{ pkgs, ... }:
{
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.yubikey-touch-detector = {
    enable = true;
    verbose = true;
  };

  # Secret storage only. The gcr ssh-agent it pulls in by default would run a
  # second SSH agent and export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh into the
  # systemd user manager, hijacking user services (e.g. yubikey-touch-detector)
  # away from gpg-agent's ssh socket that the shell and YubiKey actually use.
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
}
