{ config, pkgs, lib, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeEmulator = false;
    includeSystemImages = false;

    # Keep it minimal: pick ONE platform + ONE build-tools version
    platformVersions = [ "34" ];
    buildToolsVersions = [ "34.0.0" ];

    # Optional (leave out unless you hit missing-cmake errors)
    # cmakeVersions = [ "3.22.1" ];
  };

  androidSdk = androidComposition.androidsdk;
  sdkRoot = "${androidSdk}/libexec/android-sdk";
in
{
  home.packages = with pkgs; [
    androidSdk
    watchman
    cmake
    gnumake
    ninja
    pkg-config
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdkRoot;
    ANDROID_SDK_ROOT = sdkRoot;
  };

  home.sessionPath = [
    "${sdkRoot}/platform-tools"
    "${sdkRoot}/cmdline-tools/latest/bin"
    # remove emulator path since we’re not installing it:
    # "${sdkRoot}/emulator"
  ];
}
