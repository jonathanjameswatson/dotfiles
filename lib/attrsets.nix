{lib, ...}: {
  namesWithValue = names: value:
    builtins.listToAttrs (
      map (name: {inherit name value;}) names
    );
}
