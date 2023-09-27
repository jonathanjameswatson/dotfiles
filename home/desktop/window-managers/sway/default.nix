{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.windowManagers.sway;
in {
  options.jjw.desktop.windowManagers.sway = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    terminalCommand = mkOption {
      type = types.str;
      default = "alacritty";
    };
    launcherCommand = mkOption {
      type = types.str;
      default = "wofi --show drun";
    };
    launcherVariantCommand = mkOption {
      type = types.nullOr types.str;
      default = "wofi --show run";
    };
  };

  config = lib.mkIf cfg.enable (
    let
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
      jjw.desktop.wayland.enable = true;
      jjw.desktop.gtk.enable = true;

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
        xwayland = true;

        extraConfigEarly =
          lib.jjw.catppuccin.mkSwayVariables config.jjw.theme.palette;

        config = rec {
          modifier = "Mod4";

          input = {
            "*" = {
              xkb_layout = "gb";
            };

            "type:keyboard" = {
              xkb_options = "caps:escape";
            };
          };

          terminal = cfg.terminalCommand;
          menu = cfg.launcherCommand;
          bars = lib.mkIf config.jjw.desktop.bars.waybar.enable [
            {
              command = "waybar";
              position = "bottom";
            }
          ];

          keybindings = lib.mkOptionDefault (
            {
              "${modifier}+p" = "exec ${cfg.launcherCommand}";

              "${modifier}+Shift+Tab" = "focus prev";
              "${modifier}+Tab" = "focus next";

              "${modifier}+Shift+e" = "exec nag-graphical 'Power off?' 'swaymsg -- exec systemctl poweroff -i'";
              "${modifier}+Ctrl+Shift+e" = "exec nag-graphical 'Exit sway?' 'swaymsg exit'";
              "${modifier}+Shift+s" = "exec nag-graphical 'Suspend?' 'swaymsg exec systemctl suspend'";
              "${modifier}+x" = "exec ${lock}";
            }
            // lib.optionalAttrs (cfg.launcherVariantCommand != null) {
              "${modifier}+Shift+p" = "exec ${cfg.launcherVariantCommand}";
            }
            // lib.optionalAttrs config.jjw.desktop.notifications.swaync.enable {
              "${modifier}+n" = "exec swaync-client -t -sw";
            }
            // lib.optionalAttrs config.services.flameshot.enable {
              "Print" = "exec flameshot gui --raw | wl-copy";
              "Shift+Print" = "exec flameshot gui";
            }
          );

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

          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
        '';
      };

      programs.swaylock = {
        enable = true;
        settings = {
          color = config.jjw.theme.palette.base;
        };
      };
    }
  );
}
