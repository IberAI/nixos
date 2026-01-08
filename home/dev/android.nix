{ config, pkgs, lib, ... }:

let
  sdk = "${config.home.homeDirectory}/Android/sdk";
in
{
  # Packages you actually need
  home.packages = with pkgs; [
    android-studio
    android-tools   # provides adb/fastboot in Nix store
    gradle
    watchman
    ninja
    pkg-config
    cmake
    gnumake
    unzip
    zip
    git
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdk;
    ANDROID_SDK_ROOT = sdk;
  };

  # Modern SDK PATH (no tools/ or tools/bin)
  home.sessionPath = [
    "${sdk}/platform-tools"
    "${sdk}/emulator"
    "${sdk}/cmdline-tools/latest/bin"
  ];

  # Create SDK dir + make Expo happy by ensuring platform-tools/adb exists
  home.activation.androidSdkLayout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/Android/sdk/platform-tools"

    # If the SDK doesn't provide adb yet, symlink Nix adb to the expected location.
    if [ ! -e "$HOME/Android/sdk/platform-tools/adb" ]; then
      ln -sfn "${pkgs.android-tools}/bin/adb" "$HOME/Android/sdk/platform-tools/adb"
    fi
  '';
}
