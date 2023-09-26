{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.editors.languageServers.nixd;
in {
  options.jjw.editors.languageServers.nixd = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.nixd.overlays.default];
    home.packages = with pkgs; [
      nixd
    ];
  };
}
