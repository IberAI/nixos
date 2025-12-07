{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      # For Sway + Wayland user session
      target = "sway-session.target";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right  = [ "cpu" "memory" "network" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
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
          # Remove interface override: let Waybar pick default
          interval = 5;
          format-ethernet = "Ethernet: {ifname}";
          format-wifi     = "Wi-Fi: {essid} {signalStrength}%";
          format-disconnected = "Network: Disconnected";
        };

        battery = {
          bat = "BAT0";
          adapter = "AC";
          interval = 10;
          format = "Battery: {percentage}%";
          format-charging = "Battery: {percentage}% (Charging)";
          format-plugged  = "Battery: {percentage}% (Plugged In)";
          states = { warning = 30; critical = 15; };
        };
      };
    };

    style = ''
      * { font-family: "DejaVu Sans Mono", monospace; font-size: 11px; }
      window#waybar { background: rgba(0,0,0,0.85); color: #ffffff; }
      #clock,#cpu,#memory,#network,#battery,#workspaces button { padding: 0 6px; }
      #workspaces button.focused { color: #ffffff; border-bottom: 2px solid #ffffff; }
      #clock,#cpu,#memory,#network,#battery { padding: 0 8px; }
    '';
  };
}

