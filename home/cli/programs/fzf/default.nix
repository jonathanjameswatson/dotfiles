{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    colors = with theme.palette; {
      bg = base;
      "bg+" = surface0;
      fg = text;
      "fg+" = text;
      hl = red;
      "hl+" = red;
      spinner = rosewater;
      header = red;
      info = mauve;
      pointer = rosewater;
      marker = rosewater;
      prompt = mauve;
    };
  };
}
