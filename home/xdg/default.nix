{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    shared-mime-info
  ];

  xdg = {
    userDirs.enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    configFile."mimeapps.list".force = true;
  };
}
