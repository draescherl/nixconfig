{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./desktops
    ./editors
    ./packages
    ./security.nix
    ./system
    ./users.nix
    ./virtualisation.nix
  ];
}
