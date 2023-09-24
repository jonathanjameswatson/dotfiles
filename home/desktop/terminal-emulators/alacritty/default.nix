{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${inputs.catppuccin-alacritty}/catppuccin-${config.jjw.theme.variant}.yml"];
      font.size = 13.5;
    };
  };
}
