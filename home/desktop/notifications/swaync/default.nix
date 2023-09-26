{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.notifications.swaync;
in {
  options.jjw.desktop.notifications.swaync = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];

    wayland.windowManager.sway.extraConfig = ''
      exec swaync
    '';

    xdg.configFile."swaync/style.css".text = ''
      ${lib.jjw.catppuccin.mkGtkCssVariables config.jjw.theme.palette}
      ${builtins.readFile ./style.css}
    '';
  };
}
