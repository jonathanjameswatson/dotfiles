{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  savePath = "${config.xdg.userDirs.pictures}/Screenshots";
in {
  services.flameshot = {
    enable = true;
    package = pkgs.flameshot-wayland;
    settings = {
      General = with config.jjw.theme.palette; {
        checkForUpdates = false;
        disabledTrayIcon = true;
        drawThickness = 2;
        inherit savePath;
        showHelp = false;
        showStartupLaunchMessage = false;
        uiColor = mauve;
        contrastUiColor = blue;
      };
    };
  };

  home.activation.flameshot = ''
    mkdir -p ${savePath}
  '';

  wayland.windowManager.sway.extraConfig = ''
    for_window [app_id="flameshot"] fullscreen enable global
  '';
}
