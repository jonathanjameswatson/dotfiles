{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  jjw.desktop.environment = "sway";

  programs.direnv.enable = true;
}
