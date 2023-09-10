{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: let
  titleTheme = lib.mapAttrs (name: value:
    if lib.isString value
    then lib.jjw.strings.toTitle value
    else value)
  theme;
  mode = lib.jjw.catppuccin.themeMode theme;
  titleMode = lib.jjw.strings.toTitle mode;
  gtkTheme = "Catppuccin-${titleTheme.variant}-Standard-${titleTheme.accent}-${titleMode}";
  catppuccinOverride = pkgs.catppuccin-gtk.override {
    accents = [theme.accent];
    size = "standard";
    variant = theme.variant;
  };
in {
  home.packages = with pkgs; [
    catppuccinOverride
    gnome.gnome-themes-extra
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
    platformTheme = "gtk";
  };

  systemd.user.sessionVariables.GTK_THEME = gtkTheme;
  home.sessionVariables.GTK_THEME = gtkTheme;

  home.activation.gtk4-fix = ''
    mkdir -p ~/.config/gtk-4.0/
    ln -sf ${catppuccinOverride}/share/themes/Catppuccin-*-${titleMode}/gtk-4.0/* ~/.config/gtk-4.0/
  '';
}
