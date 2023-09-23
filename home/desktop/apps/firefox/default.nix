{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox.enable = true;

  xdg.mimeApps.defaultApplications =
    lib.jjw.attrsets.valuesWithName
    [
      "text/html"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "application/pdf"
    ]
    "firefox.desktop";
}
