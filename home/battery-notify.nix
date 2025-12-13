{ pkgs, ... }:

let
  batteryNotify = pkgs.writeShellApplication {
    name = "battery-notify";
    runtimeInputs = [ pkgs.coreutils pkgs.dunst ];
    text = builtins.readFile ../scripts/battery-notify.sh;
  };
in
{
  systemd.user.startServices = "sd-switch";

  # Ensure dunst is up (you can keep this here even if you also import dunst.nix)
  services.dunst.enable = true;

  systemd.user.services.battery-notify = {
    Unit = {
      Description = "Battery threshold notifications (20% / 80%)";
      After = [ "graphical-session.target" "dunst.service" ];
      Wants = [ "graphical-session.target" "dunst.service" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${batteryNotify}/bin/battery-notify";
    };
  };

  systemd.user.timers.battery-notify = {
    Unit.Description = "Check battery thresholds";
    Timer = {
      Unit = "battery-notify.service";
      OnBootSec = "1m";
      OnUnitActiveSec = "2m";

      # Lets systemd coalesce wakeups (lower power/CPU)
      AccuracySec = "2m";

      # Optional: avoids exact periodic wakeups
      RandomizedDelaySec = "30s";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
