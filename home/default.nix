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
      programs.enableAll = true;
    };

    desktop = {
      environment = "sway";
      apps.enableAll = true;
    };
  };
}
