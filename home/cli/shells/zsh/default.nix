{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "fzf-tab"
      ];
      theme = "zsh-powerlevel10k/powerlevel10k";
      custom = lib.debug.traceVal "${pkgs.oh-my-zsh-custom}";
    };
    initExtraBeforeCompInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      source ~/.p10k.zsh
    '';
  };

  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
    executable = true;
  };
}
