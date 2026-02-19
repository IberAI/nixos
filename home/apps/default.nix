{pkgs, ...}: {
  imports = [
    ./keepassxc.nix
    ./iamb.nix
  ];

  home.packages = with pkgs; [
    wireshark
    kicad
    mpv
    gimp
    ffmpeg
  ];
}
