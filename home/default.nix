{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  jjw.desktop = {
    environment = "sway";
    apps.enableAll = true;
  };

  programs.direnv.enable = true;
}
