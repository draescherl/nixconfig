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
    ./system
    ./security.nix
    ./users.nix
  ];
}
