{
  inputs,
  outputs,
  nixConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = ["quiet" "splash"];
  boot.plymouth.enable = true;

  networking.hostName = "blue";

  networking.networkmanager.enable = true;

  jjw.locale.enable = true;

  console.earlySetup = true;
  console.font = "latarcyrheb-sun32";

  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Watson";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.stateVersion = "23.05";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-substituters = nixConfig.extra-substituters;
    trusted-public-keys = nixConfig.extra-trusted-public-keys;
  };

  security = {
    polkit.enable = true;

    pam.services.swaylock = {};
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.dconf.enable = true;

  jjw.greeters.greetd = {
    enable = true;
    type = "tuigreet";
    enableSilence = true;
  };

  programs.sway.enable = true;
  programs.sway.package = null;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
  environment.pathsToLink = ["/share/zsh"];

  services.devmon.enable = true;
  programs.udevil.enable = true;
}
