{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.jjw.theme = let
    inherit (lib) types mkOption;
    accents = [
      "rosewater"
      "flamingo"
      "pink"
      "mauve"
      "red"
      "maroon"
      "peach"
      "yellow"
      "green"
      "teal"
      "sky"
      "sapphire"
      "blue"
      "lavender"
    ];
    otherColors = [
      "text"
      "subtext1"
      "subtext0"
      "overlay2"
      "overlay1"
      "overlay0"
      "surface2"
      "surface1"
      "surface0"
      "base"
      "mantle"
      "crust"
    ];
    colors = accents ++ otherColors;
    themeModule = types.submodule {
      options = {
        variant = mkOption {
          type = types.enum ["latte" "frappe" "macchiato" "mocha"];
        };
        palette = builtins.listToAttrs (
          map (color: {
            name = color;
            value = mkOption {
              type = types.strMatching "#[0-9a-fA-F]{6}";
            };
          })
          colors
        );
        accent = mkOption {
          type = types.enum accents;
        };
        isDark = mkOption {
          type = types.bool;
        };
      };
    };
  in
    mkOption {
      type = themeModule;
      default = lib.jjw.catppuccin.mkTheme {
        variant = "macchiato";
        accent = "blue";
      };
    };
}
