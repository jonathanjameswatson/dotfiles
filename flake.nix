rec {
  description = "NixOS and home-manager configurations";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
      url = "github:jonathanjameswatson/nixd/80a87169db668c7eb635691809f12f38a8913e33";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/e10103d1d5e90f4c20136053ad3d4379fdcc2f33";
    };

    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17";
      flake = false;
    };

    webcord-src = {
      url = "github:SpacingBat3/WebCord/588a26cc3e1fa68d9a3ec2a91e0d2ec46bea6f11";
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
  in {
    packages = jjw-pkgs.packages;
    overlays = jjw-pkgs.overlays;

    nixosConfigurations =
      lib.mapAttrs (
        hostName: host:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs outputs nixConfig lib;};
            modules = [host.nixos.configuration];
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
                        stateVersion = "23.05";
                      };

                      nixpkgs.overlays = [
                        jjw-pkgs.overlays.jjw
                      ];
                    }
                  ]
                  ++ lib.attrsets.collect builtins.isPath (haumea.lib.load {
                    src = ./home;
                    loader = haumea.lib.loaders.path;
                  });
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
