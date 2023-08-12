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
in {
  home.packages = with pkgs; [
    waybarOverride
    networkmanagerapplet
    pavucontrol
  ];

  programs.waybar = {
    enable = true;
    package = waybarOverride;

    settings = [
      {
        modules-left = ["sway/workspaces"];
        modules-right = ["network" "pulseaudio" "clock"];

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
      }
    ];

    style = ''
      @import "${inputs.catppuccin-waybar}/themes/macchiato.css";

      ${builtins.readFile ./style.css}
    '';
  };
}
