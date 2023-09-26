{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.editors;
in {
  options.jjw.editors = let
    inherit (lib) types mkOption;
  in {
    enableAll = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enableAll {
    programs = {
      neovim.enable = true;
    };

    jjw.editors = {
      spacemacs.enable = true;
      vscode.enable = true;
    };
  };
}
