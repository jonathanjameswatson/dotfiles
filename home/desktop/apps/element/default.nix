{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.element;
in {
  options.programs.element = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (
        element-desktop.overrideAttrs (oldAttrs: rec {
          desktopItem = oldAttrs.desktopItem.override {
            exec = "element-desktop --ozone-platform=x11 %u";
          };
          installPhase = builtins.replaceStrings ["${oldAttrs.desktopItem}"] ["${desktopItem}"] oldAttrs.installPhase;
        })
      )
    ];
  };
}
