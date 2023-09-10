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
  detatched-lock = "${lock} -f";

  nag-graphical =
    pkgs.writeShellApplication
    {
      name = "nag-graphical";
      runtimeInputs = [pkgs.gnome3.zenity];
      text = ''
        if zenity --question --text="$1"; then
          $2
        fi
      '';
    };
in {
  home.packages = with pkgs; [
    nag-graphical
  ];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = detatched-lock;
      }
      {
        event = "lock";
        command = detatched-lock;
      }
    ];
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

        "Print" = "exec flameshot gui";
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

      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = theme.palette.base;
    };
  };
}
