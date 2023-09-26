{
  inputs,
  outputs,
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

    editors = {
      enableAll = true;
      languageServers.enableAll = true;
    };

    desktop = {
      environment = "sway";
      apps.enableAll = true;
    };

    xdg = {
      enableUserDirs = true;
      enableMime = true;
    };
  };
}
