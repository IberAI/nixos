{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    settings = {
      mainBar = {
        layer     = "top";
        position  = "top";
        height    = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right  = [ "cpu" "memory" "network" "backlight" "pulseaudio" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        clock = { format = "{:%Y-%m-%d %H:%M}"; };

        cpu = { format = "CPU {usage}%"; interval = 2; };
        memory = { format = "RAM {used:0.1f}G/{total:0.1f}G"; interval = 2; };

        network = {
          interval = 5;
          format-ethernet     = "Ethernet: {ifname}";
          format-wifi         = "Wi-Fi: {essid} {signalStrength}%";
          format-disconnected = "Network: Disconnected";
        };

        # Brightness (laptop panel backlight)
        backlight = {
          # If this doesn't show, set your device:
          # device = "intel_backlight";  # check /sys/class/backlight
          format = "☀ {percent}%";
          interval = 2;
          tooltip = true;
        };

        # Audio volume + connected device name
        pulseaudio = {
          format = " {volume}% {desc}";
          format-muted = " muted";
          scroll-step = 5;
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
        };

        battery = {
          bat      = "BAT0";
          adapter  = "AC";
          interval = 30;

          states = {
            warning  = 20;
            critical = 15;
          };

          format = "{capacity}%";
          format-charging    = "{capacity}% charging";
          format-discharging = "{capacity}% discharging";
          format-full        = "{capacity}% full";
          format-plugged     = "{capacity}% plugged";
        };
      };
    };

    style = ''
      * {
        font-family: "DejaVu Sans Mono", monospace;
        font-size: 11px;
      }

      window#waybar {
        background: rgba(0,0,0,0.85);
        color: #ffffff;
      }

      #clock,#cpu,#memory,#network,#backlight,#pulseaudio,#battery,#workspaces button {
        padding: 0 6px;
      }

      #workspaces button.focused {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      /* Battery color states */
      #battery.warning {
        color: #f5c542; /* amber */
      }
      #battery.critical {
        color: #ff4d4d; /* red */
        font-weight: bold;
      }
      #battery.charging, #battery.plugged {
        color: #6ee7a8; /* green */
      }
      #battery.full {
        color: #a7f3d0; /* light green */
      }

      /* Audio states */
      #pulseaudio.muted {
        color: #ff4d4d;
      }

      /* Brightness */
      #backlight {
        color: #e5e7eb; /* soft white */
      }
    '';
  };

  # Needed for right-click audio control (optional but nice)
  home.packages = with pkgs; [
    pavucontrol
  ];
}
