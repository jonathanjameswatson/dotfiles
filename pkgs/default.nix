{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) callPackage;
in rec {
  git-acquire = callPackage ./git-acquire {};
}
