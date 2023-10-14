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
  config = lib.mkIf (cfg.enable && cfg.type == "tuigreet") {
    services.greetd = {
      settings = {
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd sway";
      };
    };

    system.activationScripts.mkTuiGreetCache = let
      tuiGreetCache = "/var/cache/tuigreet";
    in ''
      mkdir -p ${tuiGreetCache}
      chown greeter:greeter ${tuiGreetCache}
      chmod 0755 ${tuiGreetCache}
    '';
  };
}
