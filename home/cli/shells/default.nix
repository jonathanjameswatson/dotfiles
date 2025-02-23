{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.cli.shells;
in {
  options.jjw.cli.shells = let
    inherit (lib) types mkOption;
  in {
    enableAll = mkOption {
      type = types.bool;
      default = false;
    };
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
    };
    enableNixSwitchAlias = mkOption {
      type = types.bool;
      default = true;
    };
    enableHomeSwitchAlias = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableAll {
      programs = {
        bash.enable = true;
        zsh.enable = true;
      };
    })

    {
      jjw.cli.shells = {
        aliases = lib.mkMerge [
          (lib.mkIf cfg.enableNixSwitchAlias {
            nix-switch = "nix flake update jjw-pkgs && sudo nixos-rebuild switch --flake ~/dotfiles";
          })

          (lib.mkIf cfg.enableHomeSwitchAlias {
            home-switch = "nix flake update jjw-pkgs && home-manager switch --flake ~/dotfiles#\"$(whoami)@$(hostname)\"";
          })
        ];
      };
    }
  ];
}
