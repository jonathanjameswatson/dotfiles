{
  pkgs ? import <nixpkgs> {},
  git-acquire-src,
}: let
  inherit (pkgs) callPackage;
in rec {
  git-acquire = callPackage ./git-acquire {inherit git-acquire-src;};
  oh-my-zsh-custom = callPackage ./oh-my-zsh-custom {};
}
