{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    amberol
  ];

  xdg.mimeApps.defaultApplications =
    lib.jjw.attrsets.valuesWithName
    (map
      (audioType: "audio/${audioType}")
      [
        "mpeg"
        "wav"
        "x-aac"
        "x-aiff"
        "x-ape"
        "x-flac"
        "x-m4a"
        "x-m4b"
        "x-mp1"
        "x-mp2"
        "x-mp3"
        "x-mpg"
        "x-mpeg"
        "x-mpegurl"
        "x-opus+ogg"
        "x-pn-aiff"
        "x-pn-au"
        "x-pn-wav"
        "x-speex"
        "x-vorbis"
        "x-vorbis+ogg"
        "x-wavpack"
      ])
    "io.bassi.Amberol.desktop";
}
