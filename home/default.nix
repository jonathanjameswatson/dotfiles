{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/sway
    ./modules/spacemacs
    ./modules/neovim
    ./modules/git
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    home = {
      username = "jonathan";
      homeDirectory = "/home/jonathan";
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "23.05";

    home.packages = with pkgs; [
      networkmanagerapplet
    ];

    programs.firefox.enable = true;
  };
}
