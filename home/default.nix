{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  jjw = {
    cli = {
      shells.enableAll = true;
    };

    desktop = {
      environment = "sway";
      apps.enableAll = true;
    };
  };

  programs.direnv.enable = true;
}
