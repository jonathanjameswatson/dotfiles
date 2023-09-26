{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.cli.programs;
in {
  options.jjw.cli.programs = let
    inherit (lib) types mkOption;
  in {
    enableAll = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enableAll {
    programs = {
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      thefuck.enable = true;
      extra.enable = true;
    };
  };
}
