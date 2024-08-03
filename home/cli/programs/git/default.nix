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

        url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
          "ssh://git@gitlab.com/" = {
            insteadOf = "https://gitlab.com/";
          };
          "ssh://git@bitbucket.com/" = {
            insteadOf = "https://bitbucket.com/";
          };
        };
      };
    };

    programs.ssh.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}
