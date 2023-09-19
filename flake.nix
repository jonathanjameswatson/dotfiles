{
  description = "NixOS and home-manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jjw-pkgs = {
      url = "path:./pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    flake-compat = {
      url = "github:jonathanjameswatson/flake-compat/8bf105319d44f6b9f0d764efa4fdef9f1cc9ba1c";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils/ff7b65b44d01cf9ba6a71320833626af21126384";

    nixd = {
      url = "github:jonathanjameswatson/nixd/f1b6c54111237bc54cd346b1ede2164e6f50cd3b";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/e10103d1d5e90f4c20136053ad3d4379fdcc2f33";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    jjw-pkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend (self: super: {jjw = import ./lib {lib = self;};} // home-manager.lib);
    inherit (self) outputs;
    theme = lib.jjw.catppuccin.mkTheme {
      variant = "macchiato";
      accent = "blue";
    };
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages = jjw-pkgs.packages;
    overlays = jjw-pkgs.overlays;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs lib theme;};
      modules = [./nixos/configuration.nix];
    };

    homeConfigurations = {
      "jonathan@nixos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs outputs lib theme;};
        modules = [
          ./home
          {
            home = {
              username = "jonathan";
              homeDirectory = "/home/jonathan";
              stateVersion = "23.05";
            };

            nixpkgs.overlays = [
              jjw-pkgs.overlays.jjw
            ];
          }
        ];
      };
    };
  };
}
