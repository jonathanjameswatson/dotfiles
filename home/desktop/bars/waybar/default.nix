{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.bars.waybar;
in {
  options.jjw.desktop.bars.waybar = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    enableAudio = mkOption {
      type = types.bool;
      default = true;
    };
    enableBluetooth = mkOption {
      type = types.bool;
      default = true;
    };
    enableBattery = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    let
      waybarOverride = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
      toggleBluetooth = pkgs.writeShellApplication {
        name = "toggle-bluetooth";
        text = ''
          if bluetoothctl show | grep -q "Powered: no"; then
              bluetoothctl power on >> /dev/null
          else
              bluetoothctl power off >> /dev/null
          fi
        '';
      };
    in {
      home.packages = with pkgs;
        [
          networkmanagerapplet
          pavucontrol
        ]
        ++ lib.optionals cfg.enableAudio [
          pavucontrol
        ]
        ++ lib.optionals cfg.enableBluetooth [
          blueman
          toggleBluetooth
        ];

      services.mpd.enable = lib.mkIf cfg.enableAudio true;

      programs.waybar = {
        enable = true;
        package = waybarOverride;

        settings = [
          {
            modules-left = ["sway/workspaces"];
            modules-right =
              [
                "network"
              ]
              ++ lib.optionals cfg.enableAudio [
                "pulseaudio"
              ]
              ++ lib.optionals cfg.enableBluetooth [
                "bluetooth"
              ]
              ++ [
                "clock"
              ]
              ++ lib.optionals cfg.enableBattery [
                "battery"
              ]
              ++ lib.optionals config.jjw.desktop.notifications.swaync.enable [
                "custom/notification"
              ]
              ++ [
                "tray"
              ];

            network = {
              format = "{ifname}";
              format-wifi = "{essid} ({signalStrength}%)";
              format-ethernet = "{ipaddr}/{cidr}";
              format-disconnected = "Disconnected";
              tooltip-format = "{ifname} via {gwaddr}";
              tooltip-format-wifi = "{essid} ({signalStrength}%)";
              tooltip-format-ethernet = "{ifname}";
              tooltip-format-disconnected = "Disconnected";
              max-length = 50;
              on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            };

            pulseaudio = lib.mkIf cfg.enableAudio {
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            };

            bluetooth = lib.mkIf cfg.enableBluetooth {
              format = " {status}";
              format-connected = " {device_alias}";
              format-connected-battery = " {device_alias} {device_battery_percentage}%";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              on-click = "${pkgs.blueman}/bin/blueman-manager";
              on-click-right = "${toggleBluetooth}/bin/toggle-bluetooth";
            };

            battery = {
              interval = 10;
              format = "{capacity}%";
              format-charging = " {capacity}%";
              format-plugged = "  {capacity}%";
              format-full = " {capacity}%";
            };

            "custom/notification" = {
              format = "{icon}";
              format-icons = let
                mkIcon = {
                  notification,
                  dnd,
                  inhibited,
                }:
                  if dnd
                  then "󱏬"
                  else if notification
                  then "󰅸"
                  else "󰂜";
                mkIconName = {
                  notification,
                  dnd,
                  inhibited,
                }:
                  (
                    if dnd
                    then "dnd-"
                    else ""
                  )
                  + (
                    if inhibited
                    then "inhibited-"
                    else ""
                  )
                  + (
                    if notification
                    then "notification"
                    else "none"
                  );
                bools = [true false];
                events =
                  map
                  (attrs: {
                    name = mkIconName attrs;
                    value = mkIcon attrs;
                  })
                  (
                    lib.cartesianProduct
                    {
                      notification = bools;
                      dnd = bools;
                      inhibited = bools;
                    }
                  );
              in
                builtins.listToAttrs events;
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
              align = 0;
            };

            tray = {
              spacing = 10;
            };
          }
        ];

        style = ''
          ${lib.jjw.catppuccin.mkGtkCssVariables config.jjw.theme.palette}
          ${builtins.readFile ./style.css}
        '';
      };
    }
  );
}
