{ pkgs, ... }:

let
  batteryNotify = pkgs.writeShellApplication {
    name = "battery-notify";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.dunst
      pkgs.upower     # provides: upower --monitor
      pkgs.systemd    # provides: udevadm fallback
    ];
    text = builtins.readFile ./scripts/battery-notify.sh;
  };
in
{
  systemd.user.startServices = "sd-switch";

  systemd.user.services.battery-notify = {
    Unit = {
      Description = "Battery notifications via dunstify (event-driven)";
      After = [ "graphical-session.target" "dunst.service" ];
      Wants = [ "graphical-session.target" "dunst.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${batteryNotify}/bin/battery-notify --daemon";
      Restart = "always";
      RestartSec = "2s";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
