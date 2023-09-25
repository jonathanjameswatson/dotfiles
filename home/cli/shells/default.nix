{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.shells;
in {
  options.jjw.shells = let
    inherit (lib) types mkOption;
  in {
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

  config = {
    jjw.shells = {
      aliases = lib.mkMerge [
        (lib.mkIf cfg.enableNixSwitchAlias {
          nix-switch = "sudo nixos-rebuild switch --flake ~/dotfiles";
        })

        (lib.mkIf cfg.enableHomeSwitchAlias {
          home-switch = "home-manager switch --flake ~/dotfiles#\"$(whoami)@$(hostname)\" --update-input jjw-pkgs";
        })
      ];
    };
  };
}
