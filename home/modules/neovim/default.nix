{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-airline

      vim-nix
      i3config-vim

      suda-vim
    ];

    extraConfig = ''
      set clipboard=unnamedplus"
      :set number relativenumber
      :set nu rnu
    '';
  };
}
