{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.fonts;
in {
  options.jjw.desktop.fonts = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    packages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    nerdFonts = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    enableEmojis = mkOption {
      type = types.bool;
      default = true;
    };
    enableNoto = mkOption {
      type = types.bool;
      default = true;
    };
    enableLiberation = mkOption {
      type = types.bool;
      default = true;
    };
    enableCode = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    jjw.desktop.fonts = {
      packages = with pkgs;
        lib.optionals cfg.enableEmojis [
          noto-fonts-emoji
          font-awesome
        ]
        ++ lib.optionals cfg.enableNoto [
          noto-fonts
          noto-fonts-cjk-sans
        ]
        ++ lib.optionals cfg.enableLiberation [
          liberation_ttf
        ]
        ++ lib.optionals (cfg.nerdFonts != []) [
          (nerdfonts.override {fonts = cfg.nerdFonts;})
        ];

      nerdFonts =
        lib.optionals cfg.enableNoto [
          "SourceCodePro"
          "FiraCode"
          "CascadiaCode"
        ]
        ++ lib.optionals cfg.enableNoto [
          "Noto"
        ];
    };

    fonts.fontconfig.enable = true;
    home.packages = cfg.packages;
  };
}
