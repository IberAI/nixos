{ config, pkgs, lib, ... }:

let
  iniFormat = pkgs.formats.ini { };
in
{
  #########################
  # Install KeePassXC
  #########################
  home.packages = [
    pkgs.keepassxc
  ];

  #########################
  # KeePassXC config (INI)
  #########################
  # Writes: ~/.config/keepassxc/keepassxc.ini
  xdg.configFile."keepassxc/keepassxc.ini".source =
    iniFormat.generate "keepassxc.ini" {
      Browser = {
        # Same as ticking “Enable browser integration” in the GUI
        Enabled = "true";

        # Optional nice defaults:
        # SearchInAllDatabases = true;
        # MatchURLScheme = true;
      };

      # Optional Secret Service integration:
      # FdoSecrets = {
      #   Enabled = true;
      # };
    };

  #########################
  # Autostart KeePassXC
  #########################
  # Creates: ~/.config/autostart/keepassxc.desktop
  home.file.".config/autostart/keepassxc.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=KeePassXC
    Comment=Password Manager
    Exec=keepassxc
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  #########################
  # Librewolf native-messaging bridge
  #########################
  # Create (or update) a symlink:
  #   ~/.librewolf/native-messaging-hosts -> ~/.mozilla/native-messaging-hosts
  home.activation.librewolfKeePassSymlink =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.librewolf"
      mkdir -p "$HOME/.mozilla/native-messaging-hosts"
      ln -sfn "$HOME/.mozilla/native-messaging-hosts" \
              "$HOME/.librewolf/native-messaging-hosts"
    '';
}

