{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.fzf = {
    enableZshIntegration = false;
    colors = with config.jjw.theme.palette; {
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
