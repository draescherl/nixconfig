{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gnome.nix
    ./sway.nix
  ];

  options = {
    desktops = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "gnome"
          "sway"
        ]
      );
      default = [ ];
      description = "List of desktop environments to install";
    };
  };

  # Common options for all desktop environments
  config = {
    hardware.graphics.enable = true;
    services.printing.enable = true;
    services.xserver.enable = true;

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
  };
}
