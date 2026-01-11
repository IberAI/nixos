{ config, pkgs, ... }:

let
  # Android SDK from nixpkgs androidenv
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    # Tools version is relatively stable; if nixpkgs complains, remove it.
    toolsVersion = "26.1.1";

    # Modern Expo/RN builds commonly need API 35 + Build Tools 35.x
    platformVersions = [ "35" ];
    buildToolsVersions = [ "35.0.0" ];

    includePlatformTools = true;  # adb
    includeEmulator = true;       # emulator binary
    includeCmdlineTools = true;   # sdkmanager/avdmanager

    # NDK is only strictly needed for some native builds; harmless to include.
    includeNDK = true;

    # IMPORTANT:
    # Avoid pinning ndkVersions unless you *know* your nixpkgs has that exact version.
    # Pinning the wrong one can cause evaluation errors.
    # ndkVersions = [ "26.1.10909125" ];
  };

  androidSdk = androidPkgs.androidsdk;

  # androidenv layout
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  # Useful PATH entries for Expo/RN + Android tooling
  sdkPaths = [
    "${sdkRoot}/platform-tools"            # adb
    "${sdkRoot}/emulator"                  # emulator
    "${sdkRoot}/cmdline-tools/latest/bin"  # sdkmanager, avdmanager
    "${sdkRoot}/tools/bin"
    "${sdkRoot}/tools"
  ];
in
{
  # Licenses acceptance (you already set this system-wide; keeping here is fine too)
  nixpkgs.config.android_sdk.accept_license = true;

  home.packages = with pkgs; [
    androidSdk
    jdk17
    watchman
  ];

  # Make variables available to ALL shells + GUI apps launched in your session
  home.sessionVariables = {
    # Android Studio docs: ANDROID_HOME points to the SDK root; tools read it. :contentReference[oaicite:3]{index=3}
    ANDROID_HOME = sdkRoot;

    # Many modern tools also read ANDROID_SDK_ROOT; keep it consistent with ANDROID_HOME.
    ANDROID_SDK_ROOT = sdkRoot;

    # Java for Gradle/Android builds
    JAVA_HOME = pkgs.jdk17.home;
  };

  # Make SDK tools available everywhere (not just fish)
  home.sessionPath = sdkPaths;

  # Fish: add paths cleanly + export vars (without clobbering your other fish config)
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # Android SDK/JDK (set for fish processes)
    set -gx ANDROID_HOME "${sdkRoot}"
    set -gx ANDROID_SDK_ROOT "${sdkRoot}"
    set -gx JAVA_HOME "${pkgs.jdk17.home}"

    # Ensure tools are on PATH (deduped)
    fish_add_path -g \
      ${builtins.concatStringsSep " \\\n      " sdkPaths}
  '';
}
