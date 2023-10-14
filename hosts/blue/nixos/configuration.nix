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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = ["quiet" "splash"];
  boot.plymouth.enable = true;

  networking.hostName = "blue"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  jjw.locale.enable = true;

  console.earlySetup = true;
  console.font = "latarcyrheb-sun32";

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-substituters = nixConfig.extra-substituters;
    trusted-public-keys = nixConfig.extra-trusted-public-keys;
  };

  security = {
    polkit.enable = true;

    pam.services.swaylock = {};
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
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
