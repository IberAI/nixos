{ config, pkgs, lib, inputs, ... }:

{
  # Match this to your installation / HM version (you can keep 25.11 if you like)
  home.stateVersion = "24.11";

  ############################
  # Module imports
  ############################
  imports = [
    ./home/git.nix
    ./home/fastfetch.nix
    ./home/kitty.nix
    ./home/sway.nix
    ./home/waybar.nix
    ./home/emacs.nix
    ./home/keepassxc.nix
    ./home/nvchad.nix
    ./home/dunst.nix
    ./home/ssh.nix
    ./home/librewolf
  ];

  ############################
  # Home directory layout
  ############################
  # Automatically ensure base directories exist in $HOME
  home.activation.createBaseDirs =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME"/{Development,Tools,Documents,Downloads,Pictures,Videos,Passwords}
      mkdir -p "$HOME"/Pictures/ScreenShots
    '';

  ############################
  # Session PATH additions
  ############################
  home.sessionPath = [
    "$HOME/.config/emacs/bin/"
  ];

  # You can add more top-level HM options here later if you want.
}

