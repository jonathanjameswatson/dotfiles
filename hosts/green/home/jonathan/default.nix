{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "23.05";

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
