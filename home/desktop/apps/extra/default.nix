{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnome.baobab
    gnome.gnome-system-monitor
    gnome.gnome-logs
    gnome.gucharmap
  ];
}
