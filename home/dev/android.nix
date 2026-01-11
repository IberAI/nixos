# home/dev/android.nix
{pkgs, ...}: let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = ["35" "34"];
    buildToolsVersions = ["35.0.0" "34.0.0"];

    includeEmulator = true;

    # Expo / normal RN does NOT need NDK most of the time.
    includeNDK = false;

    # If you later need native modules / CMake builds, flip these on:
    # includeNDK = true;
    # includeCmake = true;

    # Only enable if you're sure your nixpkgs has this exact version:
    # ndkVersions = [ "26.1.10909125" ];
  };

  androidSdk = androidPkgs.androidsdk;
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  sdkPaths = [
    "${sdkRoot}/platform-tools" # adb
    "${sdkRoot}/emulator" # emulator
    "${sdkRoot}/cmdline-tools/latest/bin" # sdkmanager, avdmanager
    "${sdkRoot}/cmdline-tools/bin" # fallback path
    "${sdkRoot}/tools/bin" # older layout fallback (harmless)
    "${sdkRoot}/tools" # older layout fallback (harmless)
  ];
in {
  home = {
    packages = with pkgs; [
      androidSdk
      jdk17
      watchman

      # Useful for debugging Android builds / RN tooling
      gradle
      unzip
      zip
      which
      file
    ];

    sessionVariables = {
      ANDROID_HOME = sdkRoot;
      ANDROID_SDK_ROOT = sdkRoot;

      # Many Gradle/Android tools rely on this
      JAVA_HOME = pkgs.jdk17.home;

      # Expo/RN tooling is happier when locale is sane
      LANG = "en_US.UTF-8";
    };

    # Makes PATH entries available to fish + GUI-launched apps
    sessionPath = sdkPaths;
  };
}
