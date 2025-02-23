{
  inputs,
  outputs,
  nixConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  plymouth =
    pkgs.plymouth.override {systemd = config.boot.initrd.systemd.package;};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = let
    kernelModules = [
      "drm_kms_helper"
      "intel_agp"
      "i915"
    ];
  in {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      systemd.enable = true;
      inherit kernelModules;
      availableKernelModules = kernelModules;
      verbose = false;
    };

    consoleLogLevel = 3;

    kernelParams = [
      "fbcon=nodefer"
      "logo.nologo"
      "quiet"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    inherit kernelModules;
    blacklistedKernelModules = ["snd_pcsp" "nouveau"];

    plymouth = let
      theme = "hexa_retro";
    in {
      enable = true;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {selected_themes = [theme];})
      ];
      inherit theme;
      extraConfig = ''
        ShowDelay=0
      '';
    };
  };

  powerManagement.powerDownCommands = ''
    ${lib.getExe plymouth} --show-splash
  '';
  powerManagement.resumeCommands = ''
    ${lib.getExe plymouth} --quit
  '';

  networking.hostName = "green";

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  jjw.locale.enable = true;

  console.earlySetup = true;
  console.font = "latarcyrheb-sun32";

  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Watson";
    extraGroups = ["networkmanager" "wheel" "scanner" "lp" "plugdev"];
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

  jjw.printer.enable = true;

  jjw.udev.enable = true;
}
