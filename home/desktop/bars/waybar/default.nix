{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: let
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
  home.packages = with pkgs; [
    networkmanagerapplet
    pavucontrol
    blueman
    toggleBluetooth
  ];

  programs.waybar = {
    enable = true;
    package = waybarOverride;

    settings = [
      {
        modules-left = ["sway/workspaces"];
        modules-right = [
          "network"
          "pulseaudio"
          "bluetooth"
          "clock"
          "custom/notification"
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

        pulseaudio = {
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        bluetooth = {
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
                lib.cartesianProductOfSets
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
      }
    ];

    style = ''
      ${theme.gtkCssVariables}
      ${builtins.readFile ./style.css}
    '';
  };
}
