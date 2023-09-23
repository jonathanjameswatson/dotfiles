{lib, ...}: {
  valuesWithName = values: name:
    builtins.listToAttrs (
      map (lib.attrsets.nameValuePair name) values
    );
}
