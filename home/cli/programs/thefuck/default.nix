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
  config = lib.mkIf cfg.enable {
    xdg.configFile.thefuck = {
      source = ./config;
      recursive = true;
    };
  };
}
