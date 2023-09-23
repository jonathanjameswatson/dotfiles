{
  pkgs ? import <nixpkgs> {},
  git-acquire-src,
  zsh-nix-shell-src,
  nix-zsh-completions-src,
  wl-clip-persist-src,
  flameshot-wayland-src,
  flameshot-wayland-patch,
}: let
  inherit (pkgs) callPackage;
in rec {
  git-acquire = callPackage ./git-acquire {inherit git-acquire-src;};
  oh-my-zsh-custom = callPackage ./oh-my-zsh-custom {
    inherit
      zsh-nix-shell-src
      nix-zsh-completions-src
      ;
  };
  wl-clip-persist = callPackage ./wl-clip-persist {inherit wl-clip-persist-src;};
  flameshot-wayland = callPackage ./flameshot-wayland {
    inherit
      flameshot-wayland-src
      flameshot-wayland-patch
      ;
  };
}
