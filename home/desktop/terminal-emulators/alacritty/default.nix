{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${inputs.catppuccin-alacritty}/catppuccin-${theme.variant}.yml"];
      font.size = 13.5;
    };
  };
}
