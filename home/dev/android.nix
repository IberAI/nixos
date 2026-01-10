{ config, pkgs, lib, ... }:

let
  sdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";
  jdk = pkgs.jdk17;

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion  = "latest";
    platformToolsVersion = "latest";

    # Do NOT include NDK/CMake/emulator here if you want Gradle to download/install them
    includeNDK = false;
    includeCmake = false;
    includeEmulator = false;
    includeSystemImages = false;

    # These can be omitted; Gradle will download to sdkRoot as needed
    platformVersions   = [ ];
    buildToolsVersions = [ ];

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

  # Enable Gradle/AGP SDK downloads (correct place)
  home.file.".gradle/gradle.properties".text = ''
    android.builder.sdkDownload=true
  '';

  home.sessionVariables = {
    ANDROID_SDK_ROOT = sdkRoot;
    ANDROID_HOME = sdkRoot;
    JAVA_HOME = "${jdk}";
  };

  systemd.user.sessionVariables = {
    ANDROID_SDK_ROOT = sdkRoot;
    ANDROID_HOME = sdkRoot;
  };

  home.sessionPath = [
    "${sdkRoot}/platform-tools"
    "${sdkRoot}/cmdline-tools/latest/bin"
  ];

  # Seed the writable SDK with cmdline-tools + platform-tools + (optional) licenses
  home.activation.seedAndroidSdk = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    mkdir -p "${sdkRoot}"
    mkdir -p "${sdkRoot}/cmdline-tools"
    mkdir -p "${sdkRoot}/licenses"

    # cmdline-tools (so Gradle can invoke sdkmanager internally)
    if [ ! -d "${sdkRoot}/cmdline-tools/latest" ] && [ -d "${storeSdkRoot}/cmdline-tools/latest" ]; then
      cp -a "${storeSdkRoot}/cmdline-tools/latest" "${sdkRoot}/cmdline-tools/"
    fi

    # platform-tools (adb)
    if [ ! -d "${sdkRoot}/platform-tools" ] && [ -d "${storeSdkRoot}/platform-tools" ]; then
      cp -a "${storeSdkRoot}/platform-tools" "${sdkRoot}/"
    fi

    # seed licenses if present (helps)
    if [ -d "${storeSdkRoot}/licenses" ] && [ -z "$(ls -A "${sdkRoot}/licenses" 2>/dev/null || true)" ]; then
      cp -a "${storeSdkRoot}/licenses/." "${sdkRoot}/licenses/" || true
    fi
  '';
}
