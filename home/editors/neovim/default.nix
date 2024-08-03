{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-airline

      vim-nix
      i3config-vim

      vim-suda
    ];

    extraConfig = ''
      set clipboard=unnamedplus"
      :set number relativenumber
      :set nu rnu
    '';
  };
}
