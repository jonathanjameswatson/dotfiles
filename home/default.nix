{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/sway
    ./modules/waybar
    ./modules/wofi
    ./modules/spacemacs
    ./modules/neovim
    ./modules/git
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

    home.packages = with pkgs; [
      discord
    ];

    programs.firefox.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    xdg.userDirs.enable = true;
    services.mpd.enable = true;
  };
}
