{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.amberol;
in {
  options.programs.amberol = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      amberol
    ];

    xdg.mimeApps.defaultApplications =
      lib.jjw.attrsets.namesWithValue
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
  };
}
