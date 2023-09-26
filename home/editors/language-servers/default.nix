{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.editors.languageServers;
in {
  options.jjw.editors.languageServers = let
    inherit (lib) types mkOption;
  in {
    enableAll = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enableAll {
    jjw.editors.languageServers = {
      nixd.enable = true;
      extra.enable = true;
    };
  };
}
