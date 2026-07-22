{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Fix for read-only filesystem on resume after lock/suspend.
  services.udev.extraRules = ''
    SUBSYSTEM=="pci", ACTION=="add", ATTR{vendor}=="0x144d", ATTR{device}=="0xa80a", RUN+="/bin/sh -c 'echo 0 | tee /sys/bus/pci/devices/$kernel/d3cold_allowed'"
    SUBSYSTEM=="pci", ACTION=="add", ATTR{vendor}=="0x144d", ATTR{device}=="0xa808", RUN+="/bin/sh -c 'echo 0 | tee /sys/bus/pci/devices/$kernel/d3cold_allowed'"
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
