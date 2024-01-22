{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.nixgl;
in {
  options.programs.nixgl = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nixgl.overlay
    ];

    home.packages = with pkgs; [
      nixgl.nixGLIntel
    ];
  };
}
