{pkgs, ...}: {
  imports = [
    ./keepassxc.nix
  ];

  home.packages = with pkgs; [
    wireshark
    kicad
    mpv
    gimp
    ffmpeg
  ];
}
