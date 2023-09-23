{
  lib,
  stdenv,
  flameshot,
  libsForQt5,
  flameshot-wayland-src,
  flameshot-wayland-patch,
}:
flameshot.overrideAttrs (oldAttrs: {
  pname = "flameshot-wayland";
  version = "12.1.0";

  src = flameshot-wayland-src;

  patches = [
    # https://github.com/flameshot-org/flameshot/pull/3166
    flameshot-wayland-patch
  ];

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [libsForQt5.kguiaddons];
  cmakeFlags = ["-DUSE_WAYLAND_CLIPBOARD=true"];
})
