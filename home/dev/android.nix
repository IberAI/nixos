# home/dev/android.nix
{ config, pkgs, ... }:

let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = [ "35" "34" ];
    buildToolsVersions = [ "35.0.0" "34.0.0" ];
    includeEmulator = true;
    includeNDK = true;

    # Only enable if you're sure your nixpkgs has this exact version:
    # ndkVersions = [ "26.1.10909125" ];
  };

  androidSdk = androidPkgs.androidsdk;
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  sdkPaths = [
    "${sdkRoot}/platform-tools"          # adb
    "${sdkRoot}/emulator"                # emulator
    "${sdkRoot}/cmdline-tools/latest/bin" # sdkmanager, avdmanager (often here)
    "${sdkRoot}/cmdline-tools/bin"        # fallback on some layouts
    "${sdkRoot}/build-tools/35.0.0"       # optional convenience
    "${sdkRoot}/build-tools/34.0.0"       # optional convenience
  ];
in
{
  home.packages = with pkgs; [
    androidSdk
    jdk17
    watchman
  ];

  home.sessionVariables = {
    ANDROID_HOME = sdkRoot;
    ANDROID_SDK_ROOT = sdkRoot;
    JAVA_HOME = pkgs.jdk17.home;
  };

  # This is what makes fish (and other shells) get the PATH entries “globally”
  home.sessionPath = sdkPaths;
}
