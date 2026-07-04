{ pkgs, ... }: {
  imports = [
    ./battery-notify.nix
    ./dunst.nix
    ./fastfetch.nix
    ./sway.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    rofi
    wlogout
    grim
    slurp
    wl-clipboard
    wf-recorder
    udiskie
    adwaita-icon-theme
  ];
}
