{
  inputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: let
  extraPackages = epkgs: with epkgs; [vterm];
in {
  nixpkgs.overlays = [inputs.emacs-overlay.overlay];

  services.emacs = {
    enable = true;
    package = with pkgs; (emacsPackagesFor emacs-unstable-pgtk).emacsWithPackages extraPackages;
    defaultEditor = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
    inherit extraPackages;
  };

  home.packages = with pkgs; [
    (ripgrep.override {withPCRE2 = true;})
    emacs-all-the-icons-fonts
    alejandra
    python3
    (pkgs.writeShellApplication {
      name = "alejandra-quiet";
      runtimeInputs = [alejandra];
      text = ''
        exec alejandra -q "''${@}"
      '';
    })
  ];

  home.file.".spacemacs.d" = {
    source = pkgs.stdenv.mkDerivation {
      name = ".spacemacs.d";
      src = builtins.path {
        name = ".spacemacs.d";
        path = ./.spacemacs.d;
      };
      sourceRoot = ".";
      installPhase = ''
        substituteInPlace .spacemacs.d/init.el \
            --subst-var-by catppuccin-variant "${theme.variant}"
        mkdir -p $out
        cp -a .spacemacs.d/. $out
      '';
      preferLocalBuild = true;
      allowSubstitutes = false;
    };
    recursive = true;
  };

  home.activation.install-spacemacs = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${pkgs.git}/bin:$PATH" $DRY_RUN_CMD ${pkgs.git-acquire}/bin/git-acquire -l ~/.emacs.d -r 4882f70e6541275969b09b52394bb9af563852f4 https://github.com/syl20bnr/spacemacs.git

    mkdir -p ~/.spacemacs.d/
    touch ~/.spacemacs.d/custom.el
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      # Extra bash shell configuration for vterm in emacs

      vterm_printf() {
        if [ -n "$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
          # Tell tmux to pass the escape sequences through
          printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "''${TERM%%-*}" = "screen" ]; then
          # GNU screen (screen, screen-256color, screen-256color-bce)
          printf "\eP\e]%s\007\e\\" "$1"
        else
          printf "\e]%s\e\\" "$1"
        fi
      }

      if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
        function clear() {
          vterm_printf "51;Evterm-clear-scrollback";
          tput clear;
        }
      fi

      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }"'echo -ne "\033]0;''${HOSTNAME}:''${PWD}\007"'

      vterm_prompt_end(){
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
      }
      PS1=$PS1'\[$(vterm_prompt_end)\]'

      vterm_cmd() {
          local vterm_elisp
          vterm_elisp=""
          while [ $# -gt 0 ]; do
              vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | ${pkgs.gnused}/bin/sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
              shift
          done
          vterm_printf "51;E$vterm_elisp"
      }

      # End vterm configuration
    '';
  };
}
