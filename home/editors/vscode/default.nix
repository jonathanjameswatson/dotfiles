{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.editors.vscode;
  isInsiders = false;
  package =
    if isInsiders
    then
      (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
        src = builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "1wa4052q80qvsa9km5bf83rldd7z989mgxzzj5v2pnq00iv4yi34";
        };
        version = "latest";

        buildInputs = oldAttrs.buildInputs ++ [pkgs.krb5];
      })
    else pkgs.vscode;
in {
  options.jjw.editors.vscode = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
    ];

    programs.vscode = {
      enable = true;
      package = package.fhs;
    };
  };
}
