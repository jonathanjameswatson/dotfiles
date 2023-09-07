{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    liberation_ttf
    (nerdfonts.override {fonts = ["SourceCodePro" "FiraCode" "CascadiaCode" "Noto"];})
  ];
in {
  imports = [
    ./modules/sway
    ./modules/waybar
    ./modules/wofi
    ./modules/spacemacs
    ./modules/neovim
    ./modules/git
    ./modules/flameshot
    ./modules/swaync
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

    home.packages = with pkgs;
      [
        discord
      ]
      ++ fonts;

    programs.firefox.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    xdg.userDirs.enable = true;
    services.mpd.enable = true;

    fonts.fontconfig.enable = true;
  };
}
