{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nodePackages_latest.vscode-json-languageserver
  ];
}
