{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "nix-shell"
        "nix-zsh-completions"
        "thefuck"
        "fzf-tab"
      ];
      theme = "zsh-powerlevel10k/powerlevel10k";
      custom = "${pkgs.oh-my-zsh-custom}";
    };
    initExtraBeforeCompInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
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
