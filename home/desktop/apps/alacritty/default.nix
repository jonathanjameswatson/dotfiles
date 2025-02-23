{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    settings = {
      general.import = ["${inputs.catppuccin-alacritty}/catppuccin-${config.jjw.theme.variant}.toml"];
      font.size = 13.5;
    };
  };
}
