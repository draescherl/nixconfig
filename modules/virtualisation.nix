{ lib, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # override systemd-nspawn service for exherbo container to use host networking & DNS
  systemd.services."systemd-nspawn@exherbo".serviceConfig = {
    ExecStart = lib.mkForce "systemd-nspawn --bind-ro=/etc/resolv.conf --quiet --keep-unit --boot --link-journal=try-guest -U --settings=override --machine=%i";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
