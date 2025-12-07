# home.nix
{ pkgs, ... }:
let
  chemacs2 = pkgs.fetchFromGitHub {
    owner = "plexus";
    repo = "chemacs2";
    rev = "c2d700b784c793cc82131ef86323801b8d6e67bb";
    sha256 = "sha256-/WtacZPr45lurS0hv+W8UGzsXY3RujkU5oGGGqjqG0Q=";
  };
in
{
  # Install chemacs2 to ~/.emacs.d (the OLD location)
  # This way it won't conflict with your XDG ~/.config/emacs
 # home.file.".emacs.d/early-init.el".source = "${chemacs2}/early-init.el";
 # home.file.".emacs.d/init.el".source = "${chemacs2}/init.el";

 # # Configure profiles
  home.file.".emacs-profiles.el".text = ''
    (("doom" . ((user-emacs-directory . "~/.config/emacs")
                (env . (("DOOMDIR" . "~/.config/doom")))))
     ("custom" . ((user-emacs-directory . "~/.config/emacs-custom"))))
  '';

 # # Set default profile
 # home.file.".emacs-profile".text = "doom";

  # Convenient aliases
  programs.zsh.shellAliases = {
    emacs-doom = "emacs --with-profile doom";
    emacs-custom = "emacs --with-profile custom";
  };
}
