{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: {
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec swaync
  '';

  xdg.configFile."swaync/style.css".text = ''
    ${theme.gtkCssVariables}
    ${builtins.readFile ./style.css}
  '';
}
