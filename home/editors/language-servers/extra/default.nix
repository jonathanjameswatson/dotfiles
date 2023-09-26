{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.editors.languageServers.extra;
in {
  options.jjw.editors.languageServers.extra = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodePackages_latest.vscode-json-languageserver
      (lib.meta.hiPrio clang-tools_16)
    ];
  };
}
