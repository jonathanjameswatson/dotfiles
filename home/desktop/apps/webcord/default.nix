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
          name = "webcord-4.6.1";
          src = inputs.webcord-src;
          npmDeps = pkgs.fetchNpmDeps {
            inherit src;
            name = "${name}-npm-deps";
            hash = "sha256-UzwLORlUeTMq3RyOHpvBrbxbwgpMBsbmfyXBhpB6pOQ="; # lib.fakeHash
          };
        });
      })
    ];

    home.packages = with pkgs; [
      webcord
    ];
  };
}
