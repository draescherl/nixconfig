{
  username,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  systemd.services."systemd-nspawn@exherbo" = {
    serviceConfig = {
      # override systemd-nspawn service for exherbo container to use host networking & DNS
      ExecStart = lib.mkForce "systemd-nspawn --bind-ro=/etc/resolv.conf --quiet --keep-unit --boot --link-journal=try-guest -U --settings=override --machine=%i";
    };
    wantedBy = [ "multi-user.target" ]; # Start on boot
  };

  users.users.${username}.packages = with pkgs; [
    docker-compose
  ];
}
