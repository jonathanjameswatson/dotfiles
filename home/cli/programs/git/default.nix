{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      userName = "Jonathan Watson";
      userEmail = "23344719+jonathanjameswatson@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.ssh.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "tty";
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}
