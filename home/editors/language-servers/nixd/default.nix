{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.nixd.overlays.default];
  home.packages = with pkgs; [
    nixd
  ];
}
