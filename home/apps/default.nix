{pkgs, ...}: {
  imports = [
    ./keepassxc.nix
    ./iamb.nix
    ./sioyek.nix
  ];

  home.packages = with pkgs; [
    wireshark
    kicad
    mpv
    gimp
    ffmpeg
    typst
    tinymist
  ];
}
