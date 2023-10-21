{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.jjw.printer;
in {
  options.jjw.printer = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [gutenprint];
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.openFirewall = true;
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [pkgs.sane-airscan];
  };
}
