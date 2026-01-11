{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting

      set -gx EDITOR nvim
      set -gx VISUAL nvim

      set -gx PAGER less
      set -gx LESS "-R"

      fish_add_path -g \
        $HOME/.local/bin \
        $HOME/bin

      if set -q SSH_AUTH_SOCK
        set -gx SSH_AUTH_SOCK $SSH_AUTH_SOCK
      end

      set -g fish_color_command green
      set -g fish_color_error red

      bind \cr history-pager

      abbr -a .. 'cd ..'
      abbr -a ... 'cd ../..'
      abbr -a ll 'ls -lah'
      abbr -a la 'ls -A'
      abbr -a g 'git'
      abbr -a v 'nvim'
      abbr -a n 'nvim'
    '';
  };
}
