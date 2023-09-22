{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tmux
    screen

    xdg-utils

    zip
    unzip

    gdb

    tree
    bat # better cat
    ocamlPackages.patdiff
    (ripgrep.override {withPCRE2 = true;})

    wget

    jq

    htop
    iotop
    killall

    strace
    ltrace

    usbutils
    pciutils
    lsof # which process is using mountpoint

    cron

    cowsay
    figlet
    neofetch
  ];
}
