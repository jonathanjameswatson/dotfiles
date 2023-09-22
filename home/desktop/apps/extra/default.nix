{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnome.nautilus
    gnome.eog
    amberol
    vlc
    gnome.baobab
    gnome.gnome-system-monitor
    gnome.gnome-logs
    gnome.gucharmap
  ];
}
