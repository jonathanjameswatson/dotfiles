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
      baobab
      gnome-system-monitor
      gnome-logs
      gucharmap
      simple-scan
      chromium
    ];
  };
}
