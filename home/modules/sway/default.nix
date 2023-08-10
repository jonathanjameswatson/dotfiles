{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  menu = "wofi --show drun";
  lock = "${pkgs.swaylock}/bin/swaylock";
  detatchedLock = "${lock} -f";
  gtkTheme = "Adwaita-dark";
  gtkThemeVariable = "Adwaita:dark";
in {
  home.packages = with pkgs; [
    swaylock
    wl-clipboard
    alacritty
    wofi
    kanshi
    waybar
    swaynotificationcenter

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
    wrapperFeatures.gtk = true;

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
        bottom = 3;
        top = 3;
        horizontal = 3;
        vertical = 3;
        inner = 3;
        left = 3;
        right = 3;
        outer = 3;
      };

      focus.wrapping = "workspace";
    };

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export GTK_THEME=${gtkThemeVariable}

      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    '';

    extraConfig = "exec swaync";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = gtkTheme;
    };
  };

  systemd.user.sessionVariables.GTK_THEME = gtkThemeVariable;
}
