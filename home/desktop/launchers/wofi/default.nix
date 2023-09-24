{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.wofi = {
    enable = true;
    style = ''
      ${lib.jjw.catppuccin.mkGtkCssVariables config.jjw.theme.palette}
      ${builtins.readFile ./style.css}
    '';
  };
}
