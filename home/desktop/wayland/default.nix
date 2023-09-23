{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
      Restart = "on-failure";
    };
  };
}
