{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jjw.greeters.greetd;
in {
  options.jjw.greeters.greetd = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    type = mkOption {
      type = types.nullOr (types.enum ["tuigreet"]);
      default = null;
    };
    enableSilence = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session.user = "greeter";
        };
      };
    }

    (lib.mkIf cfg.enableSilence {
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    })
  ]);
}
