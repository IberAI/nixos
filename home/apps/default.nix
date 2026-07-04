{pkgs, ...}: {
  imports = [
    ./keepassxc.nix
    ./iamb.nix
    ./sioyek.nix
  ];

  home.packages = with pkgs; [
    brave
    wireshark
    kicad
    mpv
    gimp
    ffmpeg
    typst
    tinymist
    openconnect
    networkmanager-openconnect
    openssh

    # Ham radio / Yaesu
    chirp
    wsjtx
    fldigi
    flrig
    hamlib

    rtl-sdr
    rtl_433
    cubicsdr
    freecad
  ];
}
