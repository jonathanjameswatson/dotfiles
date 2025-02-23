{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.eog;
in {
  options.programs.eog = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      eog
    ];

    xdg.mimeApps.defaultApplications =
      lib.jjw.attrsets.namesWithValue
      (map
        (imageType: "image/${imageType}")
        [
          "bmp"
          "gif"
          "jpeg"
          "jpg"
          "pjpeg"
          "png"
          "tiff"
          "webp"
          "x-bmp"
          "x-gray"
          "x-icb"
          "x-ico"
          "x-png"
          "x-portable-anymap"
          "x-portable-bitmap"
          "x-portable-graymap"
          "x-portable-pixmap"
          "x-xbitmap"
          "x-xpixmap"
          "x-pcx"
          "svg+xml"
          "svg+xml-compressed"
          "vnd.wap.wbmp"
          "x-icns"
        ])
      "org.gnome.eog.desktop";
  };
}
