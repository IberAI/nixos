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

      enable_audio_bell   = false;
      window_padding_width = 4;

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
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";

      # Switch tabs with Ctrl+Left / Ctrl+Right
      # (Note: this overrides word-jump in shells)
      "ctrl+right" = "next_tab";
      "ctrl+left"  = "previous_tab";

      # Switch tabs with Ctrl+1..9
      "ctrl+1" = "goto_tab 1";
      "ctrl+2" = "goto_tab 2";
      "ctrl+3" = "goto_tab 3";
      "ctrl+4" = "goto_tab 4";
      "ctrl+5" = "goto_tab 5";
      "ctrl+6" = "goto_tab 6";
      "ctrl+7" = "goto_tab 7";
      "ctrl+8" = "goto_tab 8";
      "ctrl+9" = "goto_tab 9";

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

      # Move focus between neighbors (vim style)
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+j" = "neighboring_window down";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+l" = "neighboring_window right";

      # Manual splits if you want explicit h/v splits
      "ctrl+shift+minus"     = "launch --location=hsplit --cwd=current";
      "ctrl+shift+backslash" = "launch --location=vsplit --cwd=current";

      # Resize current window
      "ctrl+shift+r" = "start_resizing_window";

      ########## LAYOUT CONTROL ##########

      # Re-apply tall 70/30 layout if things ever look weird
      "ctrl+alt+t" = "goto_layout tall:bias=70;full_size=1";
    };

    # Keep extraConfig minimal (no weird includes / scrollback hacks)
    extraConfig = ''
      # Extra kitty.conf lines can go here if you really need them.
      # Right now kept empty for maximum reliability.
    '';
  };
}

