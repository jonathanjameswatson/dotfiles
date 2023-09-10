{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) callPackage;
in rec {
  git-acquire = callPackage ./git-acquire {};
  oh-my-zsh-custom = callPackage ./oh-my-zsh-custom {};
}
