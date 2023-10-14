{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jjw.locale;
in {
  options.jjw.locale = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    localeString = mkOption {
      type = types.str;
      default = "en_GB.UTF-8";
    };
    keymap = mkOption {
      type = types.str;
      default = "uk";
    };
    xserverKeymap = mkOption {
      type = types.str;
      default = "gb";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Europe/London";
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = cfg.localeString;

    i18n.extraLocaleSettings =
      lib.jjw.attrsets.namesWithValue [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ]
      cfg.localeString;

    console.keyMap = cfg.keymap;
    services.xserver.layout = cfg.xserverKeymap;

    time = {inherit (cfg) timeZone;};
  };
}
