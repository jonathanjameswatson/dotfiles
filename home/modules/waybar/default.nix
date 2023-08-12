{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
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
    waybarOverride
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
        ];

        network = {
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ipaddr}/{cidr}";
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
      }
    ];

    style = ''
      @import "${inputs.catppuccin-waybar}/themes/macchiato.css";

      ${builtins.readFile ./style.css}
    '';
  };
}
