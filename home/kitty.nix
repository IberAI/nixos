{ config, pkgs, ... }:

{
  programs.kitty = {
    enable  = true;
    package = pkgs.kitty;

    font = {
      name = "Maple Mono NF";
      size = 10;
    };

    shellIntegration = {
      enableFishIntegration = true;
    };

    ########################
    # Core settings
    ########################
    settings = {
      # No “are you sure?” when closing last window
      confirm_os_window_close = 0;

      enable_audio_bell    = false;
      window_padding_width = 2;

      active_border_color   = "#5cedaa";
      inactive_border_color = "#b2d9c2";

      # Make tall the default, 70% main window
      # First entry is the default layout
      enabled_layouts = "tall:bias=70;full_size=1,grid,stack";

      # Tab bar
      tab_bar_edge  = "top";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 1;
      tab_title_template =
        "{index}: {title}{' [{}]'.format(num_windows) if num_windows > 1 else ''}";
    };

    ########################
    # Keybindings
    ########################
    keybindings = {
      ########## TABS ##########

      # New / close tab
      "ctrl+shift+n" = "new_tab";
      "ctrl+shift+t" = "new_tab";      # keep old habit if you like
      "ctrl+shift+q" = "close_tab";

      # Switch tabs with Ctrl+Shift+Left / Ctrl+Shift+Right
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left"  = "previous_tab";

      # Switch tabs with Ctrl+Shift+1..9 (1-based tabs)
      "ctrl+shift+1" = "goto_tab 1";
      "ctrl+shift+2" = "goto_tab 2";
      "ctrl+shift+3" = "goto_tab 3";
      "ctrl+shift+4" = "goto_tab 4";
      "ctrl+shift+5" = "goto_tab 5";
      "ctrl+shift+6" = "goto_tab 6";
      "ctrl+shift+7" = "goto_tab 7";
      "ctrl+shift+8" = "goto_tab 8";
      "ctrl+shift+9" = "goto_tab 9";

      # Move current tab left/right
      "ctrl+."     = "move_tab_forward";
      "ctrl+comma" = "move_tab_backward";

      ########## WINDOWS (SPLITS) ##########

      # New window in current tab, obeying tall layout
      "ctrl+shift+enter" = "new_window";

      # Close current window (pane)
      "ctrl+shift+w" = "close_window";

      # Cycle focus between windows in this tab
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";

      # Move focus between neighbors with Ctrl+Arrow
      "ctrl+right" = "neighboring_window right";
      "ctrl+left"  = "neighboring_window left";

      # Optional: vim-style focus (keep if you like)
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+j" = "neighboring_window down";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+l" = "neighboring_window right";

      # Manual splits if you want explicit h/v splits
      "ctrl+shift+minus"     = "launch --location=hsplit --cwd=current";
      "ctrl+shift+backslash" = "launch --location=vsplit --cwd=current";

      # Resize current window
      "ctrl+shift+r" = "start_resizing_window";

      # Focus windows by index with Ctrl+1..9 (0-based nth_window)
      "ctrl+1" = "nth_window 0";
      "ctrl+2" = "nth_window 1";
      "ctrl+3" = "nth_window 2";
      "ctrl+4" = "nth_window 3";
      "ctrl+5" = "nth_window 4";
      "ctrl+6" = "nth_window 5";
      "ctrl+7" = "nth_window 6";
      "ctrl+8" = "nth_window 7";
      "ctrl+9" = "nth_window 8";

      ########## LAYOUT CONTROL ##########

      # Re-apply tall 70/30 layout if things ever look weird
      "ctrl+alt+t" = "goto_layout tall:bias=70;full_size=1";
    };

    extraConfig = ''
      # Extra kitty.conf lines can go here if you really need them.
    '';
  };
}
