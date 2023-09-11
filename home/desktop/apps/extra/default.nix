{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    webcord
    (
      element-desktop.overrideAttrs (oldAttrs: rec {
        desktopItem = oldAttrs.desktopItem.override {
          exec = "element-desktop --ozone-platform=x11 %u";
        };
        installPhase = builtins.replaceStrings ["${oldAttrs.desktopItem}"] ["${desktopItem}"] oldAttrs.installPhase;
      })
    )
  ];
}
