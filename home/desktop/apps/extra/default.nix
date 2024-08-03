{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.extra;
in {
  options.programs.extra = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.baobab
      gnome.gnome-system-monitor
      gnome.gnome-logs
      gnome.gucharmap
      gnome.simple-scan
      chromium
    ];
  };
}
