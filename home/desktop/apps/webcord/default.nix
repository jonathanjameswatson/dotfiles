{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (_: prev: {
      webcord = prev.webcord.overrideAttrs (oldAttrs: rec {
        name = "webcord-4.4.1";
        src = inputs.webcord-src;
        npmDeps = pkgs.fetchNpmDeps {
          inherit src;
          name = "${name}-npm-deps";
          hash = "sha256-SSlSLZs97LDtL7OyfCtEGZjDVfsn5KKUgRNyL8J5M5g=";
        };
      });
    })
  ];

  home.packages = with pkgs; [
    webcord
  ];
}
