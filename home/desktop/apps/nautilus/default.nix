{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.nautilus;
in {
  options.programs.nautilus = let
    inherit (lib) types mkOption;
  in {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.nautilus
    ];

    xdg.mimeApps.defaultApplications =
      lib.jjw.attrsets.namesWithValue
      [
        "inode/directory"
        "application/x-7z-compressed"
        "application/x-7z-compressed-tar"
        "application/x-bzip"
        "application/x-bzip-compressed-tar"
        "application/x-compress"
        "application/x-compressed-tar"
        "application/x-cpio"
        "application/x-gzip"
        "application/x-lha"
        "application/x-lzip"
        "application/x-lzip-compressed-tar"
        "application/x-lzma"
        "application/x-lzma-compressed-tar"
        "application/x-tar"
        "application/x-tarz"
        "application/x-xar"
        "application/x-xz"
        "application/x-xz-compressed-tar"
        "application/zip"
        "application/gzip"
        "application/bzip2"
        "application/vnd.rar"
        "application/zstd"
        "application/x-zstd-compressed-tar"
      ]
      "org.gnome.Nautilus.desktop";
  };
}
