{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # start via systemd user service

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        # left/center/right module layout
        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" "focused_window" ];
        modules-right  = [ "cpu" "memory" "network" "bluetooth" "battery" ];

        ########################
        # Modules configuration
        ########################

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        "clock" = {
          # Example: 2025-12-07 14:32
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        "focused_window" = {
          # Display the name of the currently focused window
          format = "Focused: {name}";
          tooltip-format = "Currently focused window: {name}";
        };

        "cpu" = {
          format = "CPU {usage}%";
          tooltip = true;
        };

        "memory" = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
        };

        "network" = {
          # Let waybar auto-detect; override interface if needed
          format-wifi          = "Wi-Fi: {essid} {signalStrength}%";
          format-ethernet      = "Ethernet: {ifname}";
          format-disconnected  = "Network: Disconnected";
          tooltip = true;
        };

        "bluetooth" = {
          format              = "Bluetooth: {status}";
          format-off          = "Bluetooth: Off";
          format-on           = "Bluetooth: On";
          format-connected    = "Bluetooth: Connected to {num_connections} devices";
          tooltip-format      = "{status}";
          tooltip-format-connected = "Connected: {device_alias}";
        };

        "battery" = {
          format           = "Battery: {percentage}%";
          format-charging  = "Battery: {percentage}% (Charging)";
          format-plugged   = "Battery: {percentage}% (Plugged In)";
          states = {
            warning  = 30;
            critical = 15;
          };
          tooltip = true;
        };
      };
    };

    # Simple default styling
    style = ''
      * {
        font-family: "DejaVu Sans Mono", monospace;
        font-size: 11px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.85);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 6px;
        color: #aaaaaa;
      }

      #workspaces button.focused {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #bluetooth,
      #battery,
      #focused_window {
        padding: 0 8px;
      }

      #focused_window {
        margin-left: 10px;  # Slightly separate the focused window text from the clock
      }
    '';
  };
}

