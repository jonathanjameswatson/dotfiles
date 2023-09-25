{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.direnv.enable = true;
  services.mpd.enable = true;
}
