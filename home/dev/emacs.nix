{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  # Main config in XDG location
  xdg.configFile."emacs/init.el".text = ''
    (setq-default indent-tabs-mode nil
                  tab-width 4)

    (add-hook 'c-mode-hook
              (lambda ()
                (setq c-basic-offset 4
                      indent-tabs-mode nil)))
  '';

  # Ensure Emacs loads it (Emacs always reads ~/.emacs.d/init.el by default)
  home.file.".emacs.d/init.el".source =
    config.xdg.configFile."emacs/init.el".source;

  # (Optional but recommended) create the directory explicitly
  home.file.".emacs.d/.keep".text = "";
}
