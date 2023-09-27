{lib, ...}: {
  namesWithValue = names: value:
    builtins.listToAttrs (
      map (name: {inherit name value;}) names
    );

  attrsToList = attrs:
    map (name: {
      inherit name;
      value = attrs.${name};
    })
    (lib.attrNames attrs);
}
