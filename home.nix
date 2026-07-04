{ lib, ... }: {
  imports = [
    ./home/desktop/default.nix
    ./home/apps/default.nix
    ./home/dev/default.nix
    ./home/librewolf/default.nix
    ./home/radio/default.nix
    ./home/school/default.nix
  ];

  programs.home-manager.enable = true;

  home = {
    # keep this aligned with when you first started using HM on this machine
    stateVersion = "24.11";

    username = "iber";
    homeDirectory = "/home/iber";

    activation.createBaseDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME"/{Development,Tools,Documents,Downloads,Pictures,Videos,Passwords,School}
      mkdir -p "$HOME"/Pictures/ScreenShots
    '';

    sessionPath = [
      "$HOME/.config/emacs/bin/"
    ];
  };

  # Optional but very common quality-of-life:
  # enable XDG base dirs so apps cooperate nicely
  xdg.enable = true;
}
