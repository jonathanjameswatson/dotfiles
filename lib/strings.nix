{lib, ...}: {
  toTitle = string: let
    stringLength = lib.stringLength string;
  in
    if stringLength == 0
    then string
    else lib.toUpper (lib.substring 0 1 string) + lib.substring 1 (stringLength - 1) string;

  unlines = strings: lib.concatStrings (map (x: x + "\n") strings);
}
