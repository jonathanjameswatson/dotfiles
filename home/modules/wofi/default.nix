{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: {
  programs.wofi = {
    enable = true;
    style = ''
      ${theme.gtkCssVariables}
      ${builtins.readFile ./style.css}
    '';
  };
}
