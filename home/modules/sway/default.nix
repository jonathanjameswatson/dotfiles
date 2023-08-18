{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: let
  menu = "wofi --show drun";
  lock = "${pkgs.swaylock}/bin/swaylock";
  detatchedLock = "${lock} -f";
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
    wl-clipboard
    kanshi
    swaynotificationcenter
    catppuccinOverride
    gnome.gnome-themes-extra

    (
      pkgs.writeShellApplication {
        name = "nag-graphical";
        runtimeInputs = [gnome3.zenity];
        text = ''
          if zenity --question --text="$1"; then
            $2
          fi
        '';
      }
    )
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${inputs.catppuccin-alacritty}/catppuccin-${theme.variant}.yml"];
      font.size = 13.5;
    };
  };

  services.mako = {
    enable = true;
    maxVisible = 5;
    sort = "+time";
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = detatchedLock;
      }
      {
        event = "lock";
        command = detatchedLock;
      }
    ];
    # systemdTarget = "graphical-session.target";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      gtk = true;
    };

    extraConfigEarly = theme.swayVariables;

    config = rec {
      modifier = "Mod4";
      input."*" = {
        xkb_layout = "gb";
      };
      terminal = "alacritty";
      inherit menu;
      bars = [
        {
          command = "waybar";
          position = "bottom";
        }
      ];

      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec ${menu}";
        "${modifier}+Shift+p" = "exec wofi --show run";

        "${modifier}+Shift+Tab" = "focus prev";
        "${modifier}+Tab" = "focus next";

        "${modifier}+n" = "exec swaync-client -t -sw";

        "${modifier}+Shift+e" = "exec nag-graphical 'Power off?' 'swaymsg -- exec systemctl poweroff -i'";
        "${modifier}+Ctrl+Shift+e" = "exec nag-graphical 'Exit sway?' 'swaymsg exit'";
        "${modifier}+Shift+s" = "exec nag-graphical 'Suspend?' 'swaymsg exec systemctl suspend'";
        "${modifier}+x" = "exec ${lock}";
      };

      gaps = {
        inner = 10;
        outer = 0;
      };

      focus.wrapping = "workspace";

      colors = {
        background = "$base";
        focused = {
          border = "$blue";
          background = "$base";
          text = "$text";
          indicator = "$green";
          childBorder = "$blue";
        };
        focusedInactive = {
          border = "$mauve";
          background = "$mantle";
          text = "$text";
          indicator = "$green";
          childBorder = "$mauve";
        };
        unfocused = {
          border = "$mauve";
          background = "$crust";
          text = "$text";
          indicator = "$green";
          childBorder = "$mauve";
        };
        urgent = {
          border = "$red";
          background = "$base";
          text = "$peach";
          indicator = "$overlay0";
          childBorder = "$red";
        };
        placeholder = {
          border = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$overlay0";
          childBorder = "$overlay0";
        };
      };

      output."*" = {
        background = "$crust solid_color";
      };

      fonts = {
        names = ["SauceCodePro Nerd Font"];
        size = 12.0;
      };
    };

    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway

      export MOZ_ENABLE_WAYLAND
      export NIXOS_OZONE_WL=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1=1

      export GTK_THEME=${gtkTheme}

      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    '';

    extraConfig = "exec swaync";
  };

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

  systemd.user.sessionVariables.GTK_THEME = gtkTheme;
  home.sessionVariables.GTK_THEME = gtkTheme;

  home.activation.gtk4-fix = ''
    mkdir -p ~/.config/gtk-4.0/
    ln -sf ${catppuccinOverride}/share/themes/Catppuccin-*-${titleMode}/gtk-4.0/* ~/.config/gtk-4.0/
  '';

  programs.swaylock = {
    enable = true;
    settings = {
      color = theme.palette.base;
    };
  };
}
