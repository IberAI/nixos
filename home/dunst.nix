{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    package = pkgs.dunst;

    settings = {
      global = {
        # basic placement
        monitor = 0;
        follow = "mouse";
        geometry = "300x8-20+40";  # width x lines -x +y
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 2;
        sort = "yes";

        # look & feel
        font = "FiraCode Nerd Font 10";
        markup = "yes";
        format = "<b>%s</b>\n%b";

        alignment = "left";
        vertical_alignment = "center";

        # timeouts
        idle_threshold = 120;
        show_age_threshold = 60;
        ignore_newline = "no";

        # icons (uses your system theme)
        icon_position = "left";
        max_icon_size = 32;
        browser = "${pkgs.librewolf}/bin/librewolf";
      };

      urgency_low = {
        background = "#222222";
        foreground = "#dddddd";
        frame_color = "#444444";
        timeout = 5;
      };

      urgency_normal = {
        background = "#222222";
        foreground = "#ffffff";
        frame_color = "#5e81ac";
        timeout = 8;
      };

      urgency_critical = {
        background = "#2f0000";
        foreground = "#ffffff";
        frame_color = "#bf616a";
        timeout = 0; # stays until dismissed
      };
    };
  };
}
