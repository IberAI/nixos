{ config, pkgs, lib, ... }:

let
  androidSdk = pkgs.androidenv.androidPkgs.androidsdk;
  sdkRoot = "${androidSdk}/libexec/android-sdk";
in
{
  home.packages = with pkgs; [
    # SDK via Nix (includes platform-tools/adb)
    androidSdk

    # Usual deps for RN/Expo + Gradle
    jdk17
    nodejs_20
    watchman
    git
    unzip
    zip
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
    "${sdkRoot}/emulator"
    "${sdkRoot}/cmdline-tools/latest/bin"
  ];

  # Optional: helps some Gradle/AGP builds on NixOS (aapt2 override)
  # If you run into aapt2 errors, enable this.
  # home.sessionVariables.GRADLE_OPTS =
  #   "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdkRoot}/build-tools/28.0.3/aapt2";
}
