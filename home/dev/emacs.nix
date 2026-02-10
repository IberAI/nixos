{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  xdg.configFile."emacs/init.el".text = ''
    (setq-default indent-tabs-mode nil)
    (setq-default tab-width 4)

    (add-hook 'c-mode-hook
              (lambda ()
                (setq c-basic-offset 4)
                (setq indent-tabs-mode nil)))
  '';
}
