{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop;
in {
  options.jjw.desktop = let
    inherit (lib) types mkOption;
  in {
    environment = mkOption {
      type = types.enum ["none" "sway"];
      default = "none";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.environment == "sway") {
      jjw.desktop.windowManagers.sway.enable = true;
      jjw.desktop.bars.waybar.enable = true;
      programs.wofi.enable = true;
      jjw.desktop.notifications.swaync.enable = true;
      jjw.desktop.fonts.enable = true;
    })
  ];
}
