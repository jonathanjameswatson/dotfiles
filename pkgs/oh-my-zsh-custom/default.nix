{
  lib,
  stdenv,
  zsh-fzf-tab,
  zsh-nix-shell,
  zsh-completions,
  zsh-powerlevel10k,
}:
stdenv.mkDerivation {
  name = "oh-my-zsh-custom";

  plugins = [
    zsh-fzf-tab
  ];

  themes = [
    zsh-powerlevel10k
  ];

  installPhase = ''
    pluginOutDir="$out/plugins"
    mkdir -p "$pluginOutDir"
    themeOutDir="$out/themes"
    mkdir -p "$themeOutDir"

    for pluginDir in $plugins; do
      cp -r "$pluginDir/share/." "$pluginOutDir/"
    done

    for themeDir in $themes; do
      cp -r "$themeDir/share/." "$themeOutDir/"
    done
  '';
  dontUnpack = true;

  preferLocalBuild = true;
  allowSubstitutes = false;
}
