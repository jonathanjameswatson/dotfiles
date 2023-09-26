{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    shellAliases = config.jjw.cli.shells.aliases;
  };
}
