{
  description = "My packages and overlay";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils/ff7b65b44d01cf9ba6a71320833626af21126384";

    git-acquire-src = {
      url = "github:unnecessary-abstraction/git-acquire/1f127d9ce863e2a125f43305653e6be26e19bd8c";
      flake = false;
    };

    zsh-nix-shell-src = {
      url = "github:chisui/zsh-nix-shell/406ce293f5302fdebca56f8c59ec615743260604";
      flake = false;
    };
    nix-zsh-completions-src = {
      url = "github:nix-community/nix-zsh-completions/ae0c9ff7f709b929ba4beb8c50e4abfc74c1352a";
      flake = false;
    };

    wl-clip-persist-src = {
      url = "github:Linus789/wl-clip-persist/6ba11a2aa295d780f0b2e8f005cf176601d153b0";
      flake = false;
    };

    flameshot-wayland-src = {
      url = "github:flameshot-org/flameshot/70be63d478a271da549597d69bd4868607c0a395";
      flake = false;
    };
    flameshot-wayland-patch = {
      url = "https://github.com/flameshot-org/flameshot/commit/5fea9144501f7024344d6f29c480b000b2dcd5a6.patch";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    extra-inputs = {
      inherit
        (inputs)
        git-acquire-src
        zsh-nix-shell-src
        nix-zsh-completions-src
        wl-clip-persist-src
        flameshot-wayland-src
        flameshot-wayland-patch
        ;
    };
  in
    {
      overlays = rec {
        jjw = final: prev: import ./. ({pkgs = final;} // extra-inputs);
        default = jjw;
      };
    }
    // (flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {packages = import ./. ({inherit pkgs;} // extra-inputs);}
    ));
}
