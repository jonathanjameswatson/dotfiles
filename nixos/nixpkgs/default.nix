{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
  };
}
