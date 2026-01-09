{ config, pkgs, lib, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeEmulator = false;
    includeSystemImages = false;

    platformVersions = [ "36" ];
    buildToolsVersions = [ "36.0.0" ];

    includeNDK = true;
    ndkVersions = [ "27.1.12297006" ];
  };

  androidSdk = androidComposition.androidsdk;

  # Stable path (won't change across rebuilds)
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";
in {
  home.packages = with pkgs; [
    androidSdk
    watchman
    cmake
    gnumake
    ninja
    pkg-config
  ];

  # Make stable path point at the store SDK
  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];
}
