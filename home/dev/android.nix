{ config, pkgs, ... }:

let
  sdk = "${config.home.homeDirectory}/Android/sdk";
in
{
  home.packages = with pkgs; [
    android-tools  # adb/fastboot
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdk;
    ANDROID_SDK_ROOT = sdk;
  };

  home.sessionPath = [
    "${sdk}/platform-tools"
    "${sdk}/emulator"
    "${sdk}/tools"
    "${sdk}/tools/bin"
    "${sdk}/cmdline-tools/latest/bin"
  ];
}
