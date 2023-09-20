{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    thefuck
  ];

  xdg.configFile.thefuck = {
    source = ./config;
    recursive = true;
  };
}
