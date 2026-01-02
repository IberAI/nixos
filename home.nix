{ config, pkgs, lib, inputs, ... }:

{
  # keep this aligned with when you first started using HM on this machine
  home.stateVersion = "24.11";

  ############################
  # Module imports
  ############################
  imports = [
    ./home/desktop/default.nix
    ./home/apps/default.nix
    ./home/dev/default.nix
  ];

  ############################
  # Home Manager essentials
  ############################
  programs.home-manager.enable = true;

  # These make HM behave consistently across shells/session launches
  home.username = "iber";
  home.homeDirectory = "/home/iber";

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

  # Optional but very common quality-of-life:
  # enable XDG base dirs so apps cooperate nicely
  xdg.enable = true;
}
