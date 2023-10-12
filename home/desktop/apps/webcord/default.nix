{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.webcord;
in {
  options.programs.webcord = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (_: prev: {
        webcord = prev.webcord.overrideAttrs (oldAttrs: rec {
          name = "webcord-4.4.2";
          src = inputs.webcord-src;
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${name}-npm-deps";
            hash = "sha256-O3eFtgDO+2A7PygrLj6iT/rptnG+oR5tD2lhhz6Iwug=";
          };
        });
      })
    ];

    home.packages = with pkgs; [
      webcord
    ];
  };
}
