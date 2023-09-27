{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.xdg;
in {
  options.jjw.xdg = let
    inherit (lib) types mkOption;
  in {
    enableUserDirs = mkOption {
      type = types.bool;
      default = false;
    };
    enableMime = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config.xdg = lib.mkMerge [
    (lib.mkIf cfg.enableUserDirs {
      userDirs.enable = true;
    })

    (lib.mkIf cfg.enableMime {
      mime.enable = true;
      mimeApps.enable = true;
      configFile."mimeapps.list".force = true;
    })
  ];
}
