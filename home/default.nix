{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

    programs.direnv = {
      enable = true;
    };

    services.mpd.enable = true;
  };
}
