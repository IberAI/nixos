# home/dev/fish.nix
{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # No greeting
      set -g fish_greeting

      # Editor/pager
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx PAGER less
      set -gx LESS "-R"

      fish_add_path -g $HOME/.local/bin $HOME/bin

      # Colors
      set -g fish_color_command green
      set -g fish_color_error red

      # Keybinds
      bind \cr history-pager

      # Abbreviations
      abbr -a .. 'cd ..'
      abbr -a ... 'cd ../..'
      abbr -a ll 'ls -lah'
      abbr -a la 'ls -A'
      abbr -a g 'git'
      abbr -a v 'nvim'
      abbr -a n 'nvim'

      # ---- BurnTheShips: run iamb through Tor by default ----
      function iamb --wraps iamb --description "Run iamb through torsocks"
        command torsocks iamb $argv
      end

      # Optional: a short alias/abbr too
      abbr -a tiamb 'torsocks iamb'
    '';
  };
}
