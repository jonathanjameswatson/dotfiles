{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "application/vnd.mozilla.xul+xml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };
}
