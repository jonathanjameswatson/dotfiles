{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.apps;
in {
  options.jjw.desktop.apps = let
    inherit (lib) types mkOption;
  in {
    enableAll = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enableAll {
    programs = {
      alacritty.enable = true;
      amberol.enable = true;
      element.enable = true;
      eog.enable = true;
      firefox.enable = true;
      nautilus.enable = true;
      vlc.enable = true;
      extra.enable = true;
    };

    services.flameshot.enable = true;
  };
}
