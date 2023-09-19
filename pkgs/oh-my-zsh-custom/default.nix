{
  lib,
  stdenv,
  zsh-fzf-tab,
  zsh-powerlevel10k,
  zsh-nix-shell-src,
  nix-zsh-completions-src,
  oh-my-zsh-plugins ? null,
  oh-my-zsh-themes ? null,
}: let
  plugins =
    if oh-my-zsh-plugins != null
    then oh-my-zsh-plugins
    else [
      {
        name = "fzf-tab";
        dir = "${zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "nix-shell";
        dir = zsh-nix-shell-src;
      }
      {
        name = "nix-zsh-completions";
        dir = nix-zsh-completions-src;
      }
    ];

  themes =
    if oh-my-zsh-themes != null
    then oh-my-zsh-themes
    else [
      zsh-powerlevel10k
    ];
in
  stdenv.mkDerivation {
    name = "oh-my-zsh-custom";

    inherit themes;

    installPhase = let
      pluginCommands = lib.concatStrings (
        map ({
          name,
          dir,
        }: ''
          cp -r "${dir}/." "$pluginOutDir/${name}/"
        '')
        plugins
      );
    in ''
      pluginOutDir="$out/plugins"
      mkdir -p "$pluginOutDir"
      themeOutDir="$out/themes"
      mkdir -p "$themeOutDir"

      ${pluginCommands}

      for themeDir in $themes; do
        cp -r "$themeDir/share/." "$themeOutDir/"
      done
    '';
    dontUnpack = true;

    preferLocalBuild = true;
    allowSubstitutes = false;

    passthru = {
      oh-my-zsh-plugins = plugins;
      oh-my-zsh-themes = themes;
    };
  }
