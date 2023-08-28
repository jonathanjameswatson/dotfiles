{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Jonathan Watson";
    userEmail = "23344719+jonathanjameswatson@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ssh.enable = true;

  # https://github.com/nix-community/home-manager/blob/8bde7a651b94ba30bd0baaa9c4a08aae88cc2e92/modules/services/ssh-agent.nix

  # home.sessionVariablesExtra = ''
  #   if [[ -z "$SSH_AUTH_SOCK" ]]; then
  #     export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
  #   fi
  # '';

  # systemd.user.services.ssh-agent = {
  #   Install.WantedBy = ["default.target"];

  #   Unit = {
  #     Description = "SSH authentication agent";
  #     Documentation = "man:ssh-agent(1)";
  #   };

  #   Service = {
  #     ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent";
  #   };
  # };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
