rec {
  description = "NixOS and home-manager configurations";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jjw-pkgs = {
      url = "path:./pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    flake-compat = {
      url = "github:jonathanjameswatson/flake-compat/8bf105319d44f6b9f0d764efa4fdef9f1cc9ba1c";
      flake = false;
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd/2.6.1";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/e10103d1d5e90f4c20136053ad3d4379fdcc2f33";
    };

    nixgl = {
      url = "github:nix-community/nixGL/489d6b095ab9d289fe11af0219a9ff00fe87c7c5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty/f6cb5a5c2b404cdaceaff193b9c52317f62c62f7";
      flake = false;
    };

    webcord-src = {
      url = "github:SpacingBat3/WebCord/4ea70d8157193741325474927adf7e9e50e9e31d";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    haumea,
    jjw-pkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend (self: super: {jjw = import ./lib {lib = self;};} // home-manager.lib);
    inherit (self) outputs;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    hosts = haumea.lib.load {
      src = ./hosts;
      loader = haumea.lib.loaders.path;
    };
    allModulePathsIn = path:
      lib.attrsets.collect builtins.isPath (haumea.lib.load {
        src = path;
        loader = haumea.lib.loaders.path;
      });
  in {
    packages = jjw-pkgs.packages;
    overlays = jjw-pkgs.overlays;

    nixosConfigurations =
      lib.mapAttrs (
        hostName: host:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs outputs nixConfig lib;};
            modules =
              [host.nixos.configuration]
              ++ allModulePathsIn ./nixos;
          }
      )
      hosts;

    homeConfigurations = builtins.listToAttrs (
      lib.concatMap (
        hostNameValuePair: let
          hostName = hostNameValuePair.name;
          inherit (hostNameValuePair.value) home;
        in
          map (
            userNameValuePair: let
              username = userNameValuePair.name;
              config = userNameValuePair.value.default;
            in {
              name = "${username}@${hostName}";
              value = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {inherit inputs outputs lib;};
                modules =
                  [
                    config
                    {
                      home = {
                        inherit username;
                        homeDirectory = "/home/${username}";
                      };

                      nixpkgs.overlays = [
                        jjw-pkgs.overlays.jjw
                      ];
                    }
                  ]
                  ++ allModulePathsIn ./home;
              };
            }
          )
          (
            lib.jjw.attrsets.attrsToList home
          )
      )
      (lib.jjw.attrsets.attrsToList hosts)
    );
  };
}
