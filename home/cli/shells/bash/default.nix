{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    shellAliases = config.jjw.shells.aliases;
  };
}
