{ config, pkgs, lib, ... }:

let
  jdk = pkgs.jdk17;

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions   = [ "36" ];
    buildToolsVersions = [ "36.0.0" ];

    includeNDK = true;
    ndkVersions = [ "27.1.12297006" ];

    includeCmake = true;
    cmakeVersions = [ "3.22.1" ];

    toolsVersion = null;
  };

  storeSdkRoot = "${androidComposition.androidsdk}/libexec/android-sdk";
in
{
  home.packages = with pkgs; [
    jdk
    androidComposition.androidsdk
    android-tools # adb
    watchman
    pkg-config
    gnumake
    ninja
    python3
    rsync
  ];

  home.sessionVariables = {
    ANDROID_HOME = storeSdkRoot;
    ANDROID_SDK_ROOT = storeSdkRoot;
    JAVA_HOME = "${jdk.home}";
  };
}
