{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec swaync
  '';

  xdg.configFile."swaync/style.css".text = ''
    ${lib.jjw.catppuccin.mkGtkCssVariables config.jjw.theme.palette}
    ${builtins.readFile ./style.css}
  '';
}
