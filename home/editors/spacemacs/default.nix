{
  inputs,
  lib,
  config,
  pkgs,
  theme,
  ...
}: let
  extraPackages = epkgs: with epkgs; [vterm];
  commonShellInit = ''
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

    vterm_prompt_end() {
      vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
    }
  '';
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

  programs.bash.initExtra = ''
    # Extra bash shell configuration for vterm in emacs

    ${commonShellInit}

    if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
      function clear() {
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
      }

      PS1=$PS1'\[$(vterm_prompt_end)\]'
    fi

    # End vterm configuration
  '';

  programs.zsh.initExtra = ''
    # Extra zsh shell configuration for vterm in emacs

    ${commonShellInit}

    emacs_vterm_prompt () {
        # buffer_title_update=$(print -Pn "\e]2;%2~$\a")
        pwd_update=$(print -Pn "\e]51;A$(whoami)@$(hostname):$(pwd)\e")
        print "%{$pwd_update%}\\"
    }

    prompt_vterm_prompt_end() {
        p10k segment -t "$(emacs_vterm_prompt)"
    }

    if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
        alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'

        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
            "''${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"
            vterm_prompt_end
          )
        POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=

        if [[ ''${POWERLEVEL9K_TRANSIENT_PROMPT:-off} != 'off' ]]; then
            POWERLEVEL9K_TRANSIENT_PROMPT=off
            p10k reload
        fi
    fi

    # End vterm configuration
  '';
}
