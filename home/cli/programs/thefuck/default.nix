{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.thefuck;
in {
  options.programs.thefuck = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      thefuck
    ];

    xdg.configFile.thefuck = {
      source = ./config;
      recursive = true;
    };
  };
}
