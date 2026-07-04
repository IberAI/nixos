{ pkgs, ... }: {
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

    freecad
  ];
}
