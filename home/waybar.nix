{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    # Use systemd user service to start Waybar automatically
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        # Modules
        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" "window" ];
        modules-right  = [ "cpu" "memory" "network" "battery" "notifications" ];

        #######################
        # Module configs
        #######################

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        window = {
          format = "Focused: {title}";
          tooltip-format = "Focused window: {title}";
        };

        cpu = {
          format = "CPU {usage}%";
          interval = 2;
        };

        memory = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
          interval = 2;
        };

        network = {
          # Let Waybar auto-detect interfaces
          interface = "*";
          interval = 3;
          format-wifi         = "Wi-Fi: {essid} {signalStrength}%";
          format-ethernet     = "Ethernet: {ifname}";
          format-disconnected = "Network: Disconnected";
        };

        battery = {
          bat = "BAT0";        # check /sys/class/power_supply/
          adapter = "AC";
          interval = 5;
          format = "Battery: {percentage}%";
          format-charging  = "Battery: {percentage}% (Charging)";
          format-full      = "Battery: {percentage}%";
          format-plugged   = "Battery: {percentage}% (Plugged In)";
          tooltip = true;
          states = { warning = 30; critical = 15; };
        };

        notifications = {
          exec = "${pkgs.dunst}/bin/dunstctl count || echo 0";  # fallback 0
          interval = 5;
          format = "Notifications: {output}";
          tooltip = true;
          click-left = "${pkgs.dunst}/bin/dunstctl history";
        };
      };
    };

    style = ''
      * { font-family: "DejaVu Sans Mono", monospace; font-size: 11px; }
      window#waybar { background: rgba(0,0,0,0.85); color: #ffffff; }
      #workspaces button { padding: 0 6px; color: #aaaaaa; }
      #workspaces button.focused { color: #ffffff; border-bottom: 2px solid #ffffff; }
      #clock,#cpu,#memory,#network,#battery,#window,#notifications { padding: 0 8px; }
      #window { margin-left: 10px; }
    '';
  };
}

