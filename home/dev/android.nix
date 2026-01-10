{ config, pkgs, lib, ... }:

let
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # cmdline-tools is controlled by this in many nixpkgs versions
    cmdLineToolsVersion = "latest";

    # “Most recent” (tracks nixpkgs / repo.json in your nixpkgs)
    platformVersions   = [ "latest" ];
    buildToolsVersions = [ "latest" ];

    includeNDK   = true;
    ndkVersions  = [ "latest" ];

    includeCmake = true;
    cmakeVersions = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;

    abiVersions      = [ "x86_64" ];
    systemImageTypes = [ "google_apis" ];

    # Optional: many people set this to null to avoid legacy “tools” package weirdness
    # (keeps you on cmdline-tools)
    toolsVersion = null;
  };

  androidSdk = androidComposition.androidsdk;
in
{
  home.packages = with pkgs; [
    androidSdk
    watchman
    pkg-config
    cmake
    gnumake
    ninja
    python3
  ];

  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;

    # Some native builds look for these names
    ANDROID_NDK_HOME = "${stableSdkRoot}/ndk";
    ANDROID_NDK_ROOT = "${stableSdkRoot}/ndk";
    NDK_HOME         = "${stableSdkRoot}/ndk";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];
}
