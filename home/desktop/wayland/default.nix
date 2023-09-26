{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.jjw.desktop.wayland;
in {
  options.jjw.desktop.wayland = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      kanshi
    ];

    systemd.user.services.wl-clip-persist = {
      Unit = {
        Description = "Keep Wayland clipboard even after programs close";
        PartOf = ["graphical-session.target"];
      };

      Install = {WantedBy = ["graphical-session.target"];};

      Service = {
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both";
        Restart = "on-failure";
      };
    };
  };
}
