{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Hard-require the pinned upstream stable source to avoid accidental nixpkgs snapshot usage.
  _ = lib.assertMsg (inputs ? sioyek-src) ''
    Missing flake input "sioyek-src".

    Add this to your flake.nix inputs:

      sioyek-src = {
        url = "github:ahrm/sioyek/v2.0.0";
        flake = false;
      };

    Then run:
      nix flake lock --update-input sioyek-src
      sudo nixos-rebuild switch --flake .#nixos
  '';

  sioyekPkg = pkgs.sioyek.overrideAttrs (_old: {
    version = "2.0.0";
    src = inputs.sioyek-src; # pinned by flake.lock
  });
in {
  programs.sioyek = {
    enable = true;
    package = sioyekPkg;
  };

  # Ensure config dir exists (safe)
  home.activation.createSioyekDir = lib.hm.dag.entryBefore ["writeBoundary"] ''
    mkdir -p "$HOME/.config/sioyek"
  '';
}
