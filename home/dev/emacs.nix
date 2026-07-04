{
  config,
  pkgs,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  # Main config in XDG location
  xdg.configFile."emacs/init.el".text = ''
      ;; Basic editing defaults
      (setq-default indent-tabs-mode nil
                    tab-width 4)

      ;; Start Emacs in dired at ~/Development
      (setq initial-buffer-choice
            (lambda () (dired-noselect "~/Development")))

      ;; Theme
      (load-theme 'modus-vivendi t)
    (add-hook 'c-mode-hook
              (lambda ()
                (add-hook 'before-save-hook #'clang-format-buffer nil t)))
      ;; Small UI cleanup
      (menu-bar-mode 1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (show-paren-mode 1)
      (electric-pair-mode 1)
      (column-number-mode 1)
      (global-display-line-numbers-mode 1)

      ;; C style
      (setq c-default-style "linux"
            c-basic-offset 4)

      (add-hook 'c-mode-hook
                (lambda ()
                  (setq c-basic-offset 4
                        indent-tabs-mode nil)))

      (add-hook 'c++-mode-hook
                (lambda ()
                  (setq c-basic-offset 4
                        indent-tabs-mode nil)))

      ;; Don't show line numbers in some buffers where they are annoying
      (dolist (mode '(term-mode-hook
                      shell-mode-hook
                      eshell-mode-hook
                      dired-mode-hook))
        (add-hook mode (lambda () (display-line-numbers-mode 0))))
  '';

  # Ensure Emacs loads it
  home.file.".emacs.d/init.el".source = config.xdg.configFile."emacs/init.el".source;

  home.file.".emacs.d/.keep".text = "";
}
