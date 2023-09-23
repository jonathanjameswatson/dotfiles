{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wl-clip-persist-src,
}:
rustPlatform.buildRustPackage {
  pname = "wl-clip-persist";
  version = "0.3.1";

  src = wl-clip-persist-src;

  cargoHash = "sha256-vNxNvJ5tA323EVArJ6glNslkq/Q6u7NsIpTYO1Q3GEw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];
}
