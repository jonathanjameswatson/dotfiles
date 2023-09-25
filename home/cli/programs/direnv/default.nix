{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
