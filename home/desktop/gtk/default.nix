{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.gtk;
in {
  options.jjw.desktop.gtk = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable (
    let
      inherit (config.jjw) theme;
      titleTheme = lib.mapAttrs (name: value:
        if lib.isString value
        then lib.jjw.strings.toTitle value
        else value)
      theme;
      mode = lib.jjw.catppuccin.themeMode theme;
      titleMode = lib.jjw.strings.toTitle mode;
      gtkTheme = "catppuccin-${theme.variant}-${theme.accent}-standard";
      catppuccinOverride = pkgs.catppuccin-gtk.override {
        accents = [theme.accent];
        size = "standard";
        variant = theme.variant;
      };
    in {
      home.packages = with pkgs; [
        catppuccinOverride
        gnome-themes-extra
      ];

      gtk =
        {
          enable = true;

          theme = {
            package = catppuccinOverride;
            name = gtkTheme;
          };

          cursorTheme = {
            name = "Catppuccin-${titleTheme.variant}-${titleMode}-Cursors";
            package = pkgs.catppuccin-cursors."${theme.variant}${titleMode}";
          };

          gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        }
        // (
          if theme.isDark
          then {
            gtk3.extraConfig = {
              gtk-application-prefer-dark-theme = 1;
            };

            gtk4.extraConfig = {
              gtk-application-prefer-dark-theme = 1;
            };
          }
          else {}
        );

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      systemd.user.sessionVariables.GTK_THEME = gtkTheme;
      home.sessionVariables.GTK_THEME = gtkTheme;
    }
  );
}
