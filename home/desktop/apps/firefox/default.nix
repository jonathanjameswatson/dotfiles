{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  xdg.mimeApps = lib.mkIf config.programs.firefox.enable {
    associations.added = {
      "application/pdf" = "firefox.desktop";
    };

    defaultApplications =
      lib.jjw.attrsets.namesWithValue
      [
        "text/html"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "application/pdf"
      ]
      "firefox.desktop";
  };
}
