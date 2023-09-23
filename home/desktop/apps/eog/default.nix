{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnome.eog
  ];

  xdg.mimeApps.defaultApplications =
    lib.jjw.attrsets.valuesWithName
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
}
