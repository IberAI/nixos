{ config, pkgs, lib, ... }:

let
  sdk = "${config.home.homeDirectory}/Android/sdk";
in
{
  home.packages = with pkgs; [
    # Android IDE + tooling
    android-studio
    android-tools      # adb / fastboot
    gradle
    watchman
    ninja
    pkg-config
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdk;
    ANDROID_SDK_ROOT = sdk;
  };

  # Correct PATH entries for modern SDK layout
  home.sessionPath = [
    "${sdk}/platform-tools"
    "${sdk}/emulator"
    "${sdk}/cmdline-tools/latest/bin"
  ];

  # Ensure the directory exists (Android Studio will populate it)
  home.activation.ensureAndroidSdkDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/Android/sdk"
  '';
}
