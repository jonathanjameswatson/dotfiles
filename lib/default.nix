{lib, ...} @ args:
lib.makeExtensible (self: let
  callLib = file: import file ({lib = self;} // args);
in {
  strings = callLib ./strings.nix;
  catppuccin = callLib ./catppuccin.nix;
})
