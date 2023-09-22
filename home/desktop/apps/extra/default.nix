{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    amberol
    vlc
    gnome.baobab
    gnome.gnome-system-monitor
    gnome.gnome-logs
    gnome.gucharmap
  ];
}
